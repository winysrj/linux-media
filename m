Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:60267 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZKASK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 13:10:26 -0500
Received: by qyk4 with SMTP id 4so2222802qyk.33
        for <linux-media@vger.kernel.org>; Sun, 01 Nov 2009 10:10:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257079055.3061.19.camel@palomino.walls.org>
References: <1257020204.3087.18.camel@palomino.walls.org>
	 <829197380910311328u2879c45ep2023a99058112549@mail.gmail.com>
	 <1257036094.3181.7.camel@palomino.walls.org>
	 <de8cad4d0910311925u28895ca9q454ccf0ac1032302@mail.gmail.com>
	 <1257079055.3061.19.camel@palomino.walls.org>
Date: Sun, 1 Nov 2009 13:10:30 -0500
Message-ID: <de8cad4d0911011010g1bb3d595ge87e3b168ce41c32@mail.gmail.com>
Subject: Re: cx18: YUV frame alignment improvements
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Andy Walls <awalls@radix.net>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	Simon Farnsworth <simon.farnsworth@onelan.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 1, 2009 at 7:37 AM, Andy Walls <awalls@radix.net> wrote:
> On Sat, 2009-10-31 at 22:25 -0400, Brandon Jenkins wrote:
>> On Sat, Oct 31, 2009 at 8:41 PM, Andy Walls <awalls@radix.net> wrote:
>> > On Sat, 2009-10-31 at 16:28 -0400, Devin Heitmueller wrote:
>> >> On Sat, Oct 31, 2009 at 4:16 PM, Andy Walls <awalls@radix.net> wrote:
>> >
>> >>
>> >> Hi Andy,
>> >>
>> >> How does this code work if the cx23418 scaler is used (resulting in
>> >> the size of the frames to be non-constant)?  Or is the scaler not
>> >> currently supported in the driver?
>> >
>> > I also forgot to mention, changing size while the encoder has an analog
>> > stream running (MPEG, VBI, YUV, IDX) is not permitted by the firmware.
>> > So this change works just fine as it computes the buffer size to use
>> > just as it sets up to start the capture.
>> >
>> > Regards,
>> > Andy
>
>> Hi Andy,
>
> Hi Brandon,
>
>> I tried to pull your changes and received an error on a missing .hg.
>
> Sorry, I can't help there.  The following should work:
>
> hg clone http://linuxtv.org/hg/~awalls/cx18-yuv
>
>
>> Subsequently, I downloaded the bz2 file and upon reboot I received a
>> kernel panic due to DMA issues.
>
> Did it fail on MPEG or Digital TS captures or on a YUV capture?
>
> Did you try setting enc_yuv_bufs=0, to inhibit YUV buffer allocation, to
> see if the panic went away?
>
> Could you provide the panic to me?  Off-list is fine.
>
> If I can't get this large buffer scheme to work for the general case to
> mainatin YUV frame alignment, I'll have to figure out what will likely
> be a much more complex scheme to ensure alignment is maintained in for
> YUV streams. :(
>
> Oh, well.
>
> Regards,
> Andy
>
>
>
Hi Andy,

The panic happens upon reboot and it is only 1 line of text oddly shifted.

Kernel panic - not syncing: DMA: Memory would be corrupted

If I switch back to the current v4l-dvb drivers no issue. To switch
back I have to boot from a USB drive.

Brandon
