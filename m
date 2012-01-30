Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54866 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab2A3MB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 07:01:58 -0500
Received: by wics10 with SMTP id s10so3325574wic.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2012 04:01:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201271842570.32661@axis700.grange>
References: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
	<1327059392-29240-4-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1201251127040.18778@axis700.grange>
	<CACKLOr2zLAj4eFbjBsmN=OvCFCi9UcpWFQJF-SP4GkuP=sDwEw@mail.gmail.com>
	<Pine.LNX.4.64.1201271842570.32661@axis700.grange>
Date: Mon, 30 Jan 2012 13:01:56 +0100
Message-ID: <CACKLOr27EnPg+WV4Uvdy243VcCVxqgNBxG3yrG7gstQMJsVKug@mail.gmail.com>
Subject: Re: [PATCH 3/4] media i.MX27 camera: improve discard buffer handling.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 27 January 2012 19:02, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> (removing baruch@tkos.co.il - it bounces)
>
> On Thu, 26 Jan 2012, javier Martin wrote:
>
>> Hi Guennadi,
>>
>> On 25 January 2012 13:12, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>> > On Fri, 20 Jan 2012, Javier Martin wrote:
>> >
>> >> The way discard buffer was previously handled lead
>> >> to possible races that made a buffer that was not
>> >> yet ready to be overwritten by new video data. This
>> >> is easily detected at 25fps just adding "#define DEBUG"
>> >> to enable the "memset" check and seeing how the image
>> >> is corrupted.
>> >>
>> >> A new "discard" queue and two discard buffers have
>> >> been added to make them flow trough the pipeline
>> >> of queues and thus provide suitable event ordering.
>> >
>> > Hmm, do I understand it right, that the problem is, that while the first
>> > frame went to the discard buffer, the second one went already to a user
>> > buffer, while it wasn't ready yet?
>>
>> The problem is not only related to the discard buffer but also the way
>> valid buffers were handled in an unsafe basis.
>> For instance, the "buf->bufnum = !bufnum" issue. If you receive and
>> IRQ from bufnum = 0 you have to update buffer 0, not buffer 1.
>>
>> >And you solve this by adding one more
>> > discard buffer? Wouldn't it be possible to either not start capture until
>> > .start_streaming() is issued, which should also be the case after your
>> > patch 2/4, or, at least, just reuse one discard buffer multiple times
>> > until user buffers are available?
>> >
>> > If I understand right, you don't really introduce two discard buffers,
>> > there's still only one data buffer, but you add two discard data objects
>> > and a list to keep them on. TBH, this seems severely over-engineered to
>> > me. What's wrong with just keeping one DMA data buffer and using it as
>> > long, as needed, and checking in your ISR, whether a proper buffer is
>> > present, by looking for list_empty(active)?
>> >
>> > I added a couple of comments below, but my biggest question really is -
>> > why are these two buffer objects needed? Please, consider getting rid of
>> > them. So, this is not a full review, if the objects get removed, most of
>> > this patch will change anyway.
>>
>> 1. Why a discard buffer is needed?
>>
>> When I first took a look at the code it only supported CH1 of the PrP
>> (i.e. RGB formats) and a discard buffer was used. My first reaction
>> was trying to get rid of that trick. Both CH1 and CH2 of the PrP have
>> two pointers that the engine uses to write video frames in a ping-pong
>> basis. However, there is a big difference between both channels: if
>> you want to detect frame loss in CH1 you have to continually feed the
>> two pointers with valid memory areas because the engine is always
>> writing and you can't stop it, and this is where the discard buffer
>> function is required, but CH2 has a mechanism to stop capturing and
>> keep counting loss frames, thus a discard buffer wouldn't be needed.
>>
>> To sum up: the driver would be much cleaner without this discard
>> buffer trick but we would have to drop support for CH1 (RGB format).
>> Being respectful to CH1 support I decided to add CH2 by extending the
>> discard buffer strategy to both channels, since the code is cleaner
>> this way and doesn't make sense to manage both channels differently.
>>
>> 2. Why two discard buffer objects are needed?
>>
>> After enabling the DEBUG functionality that writes the buffers with
>> 0xaa before they are filled with video data, I discovered some of them
>> were being corrupted. When I tried to find the reason I found that we
>> really have a pipeline here:
>>
>> -------------------               -----------------------
>>   capture (n) | ------------>  active_bufs (2)|
>> -------------------              ------------------------
>>
>> where
>> "capture" has buffers that are queued and ready to be written into
>> "active_bufs" represents those buffers that are assigned to a pointer
>> in the PrP and has a maximum of 2 since there are two pointers that
>> are written in a ping-pong fashion
>
> Ok, I understand what the discard memory is used for and why you need to
> write it twice to the hardware - to those two pointers. And I can kindof
> agree, that using them uniformly with user buffers on the active list
> simplifies handling. I just don't think it's a good idea to keep two
> struct vb2_buffer instances around with no use. Maybe you could use
> something like
>
> struct mx2_buf_internal {
>        struct list_head                queue;
>        int                             bufnum;
>        bool                            discard;
> };
>
> struct mx2_buffer {
>        struct vb2_buffer               vb;
>        enum mx2_buffer_state           state;
>        struct mx2_buf_internal         internal;
> };
>
> and only use struct mx2_buf_internal for your discard buffers.

You are right, the approach you suggest is more efficient.
What I purpose is that you accept my following v3 patch series and
allow me to send a further cleanup series with the following changes:

1. Remove "goto out" from "mx2_videobuf_queue".
2. Use "list_first_entry" macro wherever possible.
3. Use new structure for internal buffers.

This would makes things a lot of easier for me and I add issues 1 and
2, which you'll probably appreciate.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
