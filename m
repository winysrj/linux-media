Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8H8oGm6016910
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 04:50:19 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8H8o3Bt004428
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 04:50:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Kfsjb-0003j1-5A
	for video4linux-list@redhat.com; Wed, 17 Sep 2008 08:50:03 +0000
Received: from thrashbarg.mansr.com ([78.86.181.100])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 08:50:03 +0000
Received: from mans by thrashbarg.mansr.com with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 08:50:03 +0000
To: video4linux-list@redhat.com
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Date: Wed, 17 Sep 2008 09:47:05 +0100
Message-ID: <yw1xy71rupkm.fsf@thrashbarg.mansr.com>
References: <1221144955.12281.6.camel@tubuntu>
	<5A47E75E594F054BAF48C5E4FC4B92AB02C42B43C8@dbde02.ent.ti.com>
	<20080912152937.GP31563@intune.research.nokia.com>
	<92846148-6506-47F1-8643-7333FB5E146A@student.utwente.nl>
	<yw1xbpyr3egz.fsf@thrashbarg.mansr.com>
	<1221480334.6312.54.camel@tubuntu>
	<yw1xljxtxl8t.fsf@thrashbarg.mansr.com>
	<1221636762.6312.117.camel@tubuntu>
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

> On Mon, 2008-09-15 at 20:27 +0100, ext Måns Rullgård wrote:
>> Tomi Valkeinen <tomi.valkeinen@nokia.com> writes:
>> 
>> > On Sat, 2008-09-13 at 22:47 +0100, ext Måns Rullgård wrote:
>> >> Koen Kooi <k.kooi@student.utwente.nl> writes:
>> >
>> >> What I don't like about the patch posted is its size.  I'm sure the
>> >> transition could be done in a sequence of smaller patches.  At the
>> >> very least, it should be possible to move existing functionality to
>> >> the new architecture, then add the new parts afterwards.  I also see
>> >> little value in keeping the old model around, as is done in the patch.
>> >
>> > I don't like the size either. However, I have no idea how the old driver
>> > could be transformed to include this functionality with a reasonable
>> > effort. The implementations are quite different.
>> >
>> > Any suggestions how I could approach this task? Only thing that comes to
>> > my mind is that there are very similar low level functions in both DSS1
>> > and DSS2 (for dispc and rfbi), that I could remove from the old place
>> > and move to arch/arm/plat-omap/dss/, but that doesn't take us very far.
>> 
>> Are the patches you posted your latest version of the code?  Do you
>> have this code in a public git repo?  I'd like to take a closer look
>> at what you've done.
>
> They are not the very latest, but they are recent enough. Unfortunately
> I don't have them on a public git. Nokia is still a bit lacking in that
> area =). They should apply to linux-omap kernel from last Thursday (I
> think the commit id is mentioned in the series file).

I don't like working on old code.  It inevitably leads to wasting time
re-doing things that have already been done in the latest version.

-- 
Måns Rullgård
mans@mansr.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
