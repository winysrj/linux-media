Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8FFHYKp002701
	for <video4linux-list@redhat.com>; Tue, 15 Sep 2009 11:17:34 -0400
Received: from vms173017pub.verizon.net (vms173017pub.verizon.net
	[206.46.173.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8FFHLeP013016
	for <video4linux-list@redhat.com>; Tue, 15 Sep 2009 11:17:21 -0400
Received: from coyote.coyote.den ([141.153.113.94]) by vms173017.mailsrvcs.net
	(Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008;
	32bit)) with ESMTPA id <0KQ0008YZQGM1850@vms173017.mailsrvcs.net> for
	video4linux-list@redhat.com; Tue, 15 Sep 2009 10:17:11 -0500 (CDT)
From: Gene Heskett <gene.heskett@verizon.net>
To: video4linux-list@redhat.com
Date: Tue, 15 Sep 2009 11:17:09 -0400
References: <20090819160700.049985b5@glory.loctelecom.ru>
	<200909150826.17805.hverkuil@xs4all.nl>
	<1253012182.3166.31.camel@palomino.walls.org>
In-reply-to: <1253012182.3166.31.camel@palomino.walls.org>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-6
Content-transfer-encoding: 7bit
Message-id: <200909151117.10060.gene.heskett@verizon.net>
Subject: Re: tuner, code for discuss
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

On Tuesday 15 September 2009, Andy Walls wrote:
>On Tue, 2009-09-15 at 08:26 +0200, Hans Verkuil wrote:
>> On Tuesday 15 September 2009 06:18:55 Michael Krufky wrote:
>> > On Tue, Sep 15, 2009 at 12:07 AM, Dmitri Belimov <d.belimov@gmail.com>
>> > wrote:
>> >
>> > Personally, I don't quite understand why we would need to add such
>> > controls NOW, while we've supported this video standard for years
>> > already.  I am not arguing against this in any way, but I dont feel
>> > like I'm qualified to accept this addition without hearing the
>> > opinions of others first.
>> >
>> > Can somebody help to shed some light?
>>
>> It's the first time I've heard about SECAM and AGC-TOP problems. I do
>> know that the TOP value is standard-dependent, although the datasheets
>> recommend different SECAM-L values only. So I can imagine that in some
>> cases you would like to adjust the TOP value a bit.
>>
>> The problem is that end-users will have no idea what to do with a control
>> like that. It falls into the category of 'advanced controls' that might
>> be nice to add but is only for very advanced users or applications.
>
>The AGC Take Over Point (TOP) is the signal level at which the 2nd stage
>of the amplifier chain (after the IF filter) takes over gain control
>from the 1st stage in the amplifier chain.  The idea is to maximize
>overall noise figure by boosting small signals as needed, but avoiding
>hittng amplifer non-linearities that generate intermodulation products
>(i.e. spectral "splatter").
>
>The TOP setting depends on the TV standard *and* the attenuation through
>the IF filter.  I'm fairly sure, it is something that one probably
>should not change to a value different from the manufacturer's
>recommendation for a particular TV standard, unless you are dealing with
>input signals in a very controlled, known range aor you have taken
>measurments inside the tuner and precisely know the loss through the IF
>filter.  If the user doesn't understand how the AGC-TOP setting will
>affect his overall system noise figure, for all inoming signal
>strengths, then the user shouldn't change it. (IMO)

As a retired broadcast engineer, I can say that generally speaking, this is a 
knob that shouldn't be enabled.  It may in some cases be able to get a db's 
worth of improvement, but the potential for worsening it by many db, by 
someone who doesn't understand the interactions, is much too high.  Given a 
knob, it will be tweaked, usually detrimentally.

>> The proposed media controller actually gives you a way of implementing
>> that as tuner-specific controls that do not show up in the regular
>> /dev/videoX control list. I have no problems adding an AGC-TOP control as
>> a tuner-specific control, but adding it as a generic control is a bad
>> idea IMHO.
>
>If needed, it should be an advanced control or, dare I say, a tunable
>via sysfs.  Setting the TOP wrong will simply degrade reception for the
>the general case of an unknown incoming signal level.
>
>The tuner-sumple code has initialization values for TOP.  Also there are
>some module options for the user to fix TOP to a value, IIRC.  Both are
>rather inflexible for someone who does want to manipulate the TOP in an
>environment where the incoming RF signal levels are controlled.
>
>Regards,
>Andy
>
>> Regards,
>>
>> 	Hans
>
>--
>video4linux-list mailing list
>Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>https://www.redhat.com/mailman/listinfo/video4linux-list
>


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

We've run out of licenses

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
