Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8FJUNE1006897
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 15:30:24 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8FJU4Se002027
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 15:30:11 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KfJlq-0001Lt-Ma
	for video4linux-list@redhat.com; Mon, 15 Sep 2008 19:30:02 +0000
Received: from thrashbarg.mansr.com ([78.86.181.100])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 19:30:02 +0000
Received: from mans by thrashbarg.mansr.com with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 19:30:02 +0000
To: video4linux-list@redhat.com
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Date: Mon, 15 Sep 2008 20:27:46 +0100
Message-ID: <yw1xljxtxl8t.fsf@thrashbarg.mansr.com>
References: <1221144955.12281.6.camel@tubuntu>
	<5A47E75E594F054BAF48C5E4FC4B92AB02C42B43C8@dbde02.ent.ti.com>
	<20080912152937.GP31563@intune.research.nokia.com>
	<92846148-6506-47F1-8643-7333FB5E146A@student.utwente.nl>
	<yw1xbpyr3egz.fsf@thrashbarg.mansr.com>
	<1221480334.6312.54.camel@tubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-omap@vger.kernel.org
Subject: Re: [PREVIEW] New display subsystem for OMAP2/3
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Tomi Valkeinen <tomi.valkeinen@nokia.com> writes:

> On Sat, 2008-09-13 at 22:47 +0100, ext Måns Rullgård wrote:
>> Koen Kooi <k.kooi@student.utwente.nl> writes:
>> 
>> > Op 12 sep 2008, om 17:29 heeft Daniel Stone het volgende geschreven:
>> >
>> >> On Fri, Sep 12, 2008 at 07:59:44PM +0530, ext Shah, Hardik wrote:
>> >>> It's time to re-design DSS frame buffer driver for the OMAP2/3.
>> >>> Current frame buffer driver is not covering the most of the
>> >>> functionality of the OMAP2/3 DSS Hardware like multiple outputs and
>> >>> multiple overlay managers supported by OMAP2/3 class of SoC. Again
>> >>> there is no V4L2 interface exposed by the DSS drivers for
>> >>> controlling the video pipelines of the DSS which is highly
>> >>> desirable feature as the video pipelines of the DSS hardware is a
>> >>> natural fit to the V4L2 architecture.
>> >>
>> >> If you want to use v4l for video output, don't let me stop you, but I
>> >> don't see that it has much actual wide use beyond TI PowerPoint
>> >> presentations about their graphical architecture.
>> >
>> > That was my thought as well, but I've encountered at least 2 products
>> > this weekend at IBC using the v4l way on omap3. One of the engineers
>> > was complaining about the lack of synchronous updates if you move
>> > various videoplanes around (think resizing video windows) which makes
>> > the video picture end up outside your nice cairo-drawn borders. So
>> > yes, it is getting used outside of TI :)
>> 
>> I'm thinking the best solution is probably to have a low-level
>> internal driver providing access to various planes, exposing as much
>> functionality as is practical.  Various user-space interfaces, such as
>> fbdev and v4l, could then be implemented on top of this with very
>> little code.  If I've understood things correctly, this is essentially
>> what the patch in this thread is doing.  This approach should let the
>> TI people and Koen's mythical friends from IBC use the v4l2 interface,
>> while still allowing the less masochistic among us to use a simpler
>> interface.
>
> Yes, that was my idea while implementing the driver.
>
>> What I don't like about the patch posted is its size.  I'm sure the
>> transition could be done in a sequence of smaller patches.  At the
>> very least, it should be possible to move existing functionality to
>> the new architecture, then add the new parts afterwards.  I also see
>> little value in keeping the old model around, as is done in the patch.
>
> I don't like the size either. However, I have no idea how the old driver
> could be transformed to include this functionality with a reasonable
> effort. The implementations are quite different.
>
> Any suggestions how I could approach this task? Only thing that comes to
> my mind is that there are very similar low level functions in both DSS1
> and DSS2 (for dispc and rfbi), that I could remove from the old place
> and move to arch/arm/plat-omap/dss/, but that doesn't take us very far.

Are the patches you posted your latest version of the code?  Do you
have this code in a public git repo?  I'd like to take a closer look
at what you've done.

> I wanted to keep the old driver because it works and contains drivers
> for many displays. At some point my driver could of course include
> these, but it may take time. Also, the old driver supports OMAP1, mine
> doesn't.

Fair enough.  Migrating the old display drivers one by one makes
sense, and when all are done, we can drop the old fb driver.

-- 
Måns Rullgård
mans@mansr.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
