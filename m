Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1JKiEtk029023
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 15:44:14 -0500
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1JKhcha000587
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 15:43:39 -0500
Message-ID: <47BB3F60.2030801@linuxtv.org>
From: mkrufky@linuxtv.org
To: mchehab@infradead.org
Date: Tue, 19 Feb 2008 15:43:12 -0500
MIME-Version: 1.0
in-reply-to: <20080219065109.199ee966@gaivota>
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: c.pascoe@itee.uq.edu.au, video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	fragabr@gmail.com
Subject: Re: [EXPERIMENTAL] cx88+xc3028 - tests are required - was: Re: Wh
	en xc3028/xc2028 will be supported?
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

Mauro Carvalho Chehab wrote:
> On Mon, 18 Feb 2008 23:44:33 -0500
> "Michael Krufky" <mkrufky@linuxtv.org> wrote:
>
>   
>> On Jan 29, 2008 9:25 AM, Mauro Carvalho Chehab <mchehab@infradead.org>
wrote:
>>     
>>> Dâniel and others,
>>>
>>>       
>>>>> Having this tested is a very good news! I'll need to merge this patch
with two
>>>>> other patches that adds DVB support for cx88/xc3028. If I can manage
to have
>>>>> some time for this merge, I'll commit and ask Linus to add this to
2.6.25.
>>>>>           
>>>>       :)
>>>>         
>>> I've merged some patches from several authors, that add xc3028 support
for
>>> cx88.
>>>
>>> The experimental tree is available at:
>>>
>>> http://linuxtv.org/hg/~mchehab/cx88-xc2028
>>>
>>> This patch series adds support for the following boards:
>>>
>>>  59 -> DVICO HDTV5 PCI Nano                                [18ac:d530]
>>>  60 -> Pinnacle Hybrid PCTV                                [12ab:1788]
>>>  61 -> Winfast TV2000 XP Global                            [107d:6f18]
>>>  62 -> PowerColor Real Angel 330                           [14f1:ea3d]
>>>  63 -> Geniatech X8000-MT DVBT                             [14f1:8852]
>>>  64 -> DViCO FusionHDTV DVB-T PRO                          [18ac:db30]
>>>
>>> In thesis, both analog and DVB support (for boards with DVB/ATSC) should
be
>>> working (*). Maybe analog audio may need an additional configuration for
some
>>> specific board (since they may require to add cfg.mts = 1 at xc3028
>>> initialization code, on cx88-cards).
>>>
>>> Please test.
>>>       
>> Mauro,
>>
>> We spoke on Thursday, and you asked me to take a look at the code in
>> your 'cx88-xc2028' tree over the weekend and fix it, if possible.
>>
>> The repository is broken after and including changeset ce6afd207b71 -
>> "Make xc3028 support more generic"  This changeset moves the
>> device-specific configuration out of the cx88-dvb.c device-specific
>> switch..case block, into a generic function.  This patch breaks
>> functionality, and imho, is not a good idea.
>>
>> Your changes assume that the analog side of the driver will come up
>> before the digital side of the driver, which is not necessarily the
>> case.  Additionally, in some cases, the tuner itself is hidden behind
>> an i2c gate that is controlled by the dvb / atsc demodulator.  Because
>> of the i2c gate, communication to the tuner might not be available at
>> the time that the i2c bus is probed.  For those reasons, the attach
>> calls to the tuner driver should be fully qualified, relative to the
>> functionality of the side of the driver that is attaching it.
>>
>> The device that I used to test is the FusionHDTV 5 PCI nano.  This
>> device uses an xc3008 (yes, that is xc3008 -- not a typo) and a
>> s5h1409 demod.  The device is capable of receiving ATSC digital
>> broadcasts and the driver does not yet support analog television.
>>
>> Steve Toth made the patch that adds atsc support for that card, and
>> his patch worked without the additional changesets that were added
>> afterwards.  I made some small fixes and enabled IR support -- see the
>> bottom of this email for my pull request.
>>
>> Your email above states that you've "merged some patches from several
>> authors".  What I recommend, in order to properly support each device,
>> would be to apply each patch for each card separately, as we do with
>> all card support additions.  We know that the original patches, as
>> submitted by the original authors work properly , since those authors
>> have conducted their own tests.
>>
>> I understand that you've made some attempts to optimize the code in an
>> effort to reduce memory consumption.  Unfortunately, these efforts
>> have broken functionality of these devices.  I think that it would
>> make more sense to work on optimizations after the basic device
>> support patches are first applied in the standard manner.  This way,
>> you would have a good point of reference for "before" and "after" that
>> testers will be able to use for comparison (and bisection).
>>
>> Since the only card that I can test is the PCI nano, please pull these
>> changesets into master for now.
>>
>> Please pull from:
>>
>> http://linuxtv.org/hg/~mkrufky/cx88-xc2028
>>
>> for:
>>
>> (91113b8955e2) 4 weeks ago	Steven Toth 	cx88: Add support for the
>> Dvico PCI Nano.
>> (394d249f03f1) 47 hours ago	Michael Krufky 	cx88: fix FusionHDTV 5 PCI
>> nano name and enable IR support
>>     
>
> Michael,
>
> It is not that simple. Steven patch works for DTV on PCI Nano; Christopher
> patches for some other DiVCO boards (DTV also); my port of Markus patch
for
> other boards (tested by Dâniel Fraga - Analog TV).
>   

What does one board have to do with another?  Just because these boards 
all use xceive tuners does not mean that they should be grouped together.


> The point is not saving memory. The point is that tuner-xc2028 requires
just
> one callback. The callback should work properly for DTV, Analog and Radio.
It
> makes no sense to have such generic callback inside cx88-dvb. It should be
at
> cx88xx module, instead.
>   
I agree that there should be in a single callback.  The appropriate 
place for this callback should be inside cx88-cards.c , and you'll have 
to include a prototype for this callback function in cx88.h.

Because the user has the ability to load cx8800 without cx88-dvb, and 
likewise, the user has the ability to load cx88-dvb without cx8800, the 
attach call must be fully qualified such that the other side of the 
driver is not required to be loaded in order for the tuner to work.  
Each attach call will need to include a pointer to this callback.  The 
tuner driver should ignore the callback parameter in the attach function 
if the callback is already defined -- this will allow for a user that 
loads cx8800 without cx88-dvb to use the tuner.  Likewise, this will 
also allow users that load cx88-dvb but not cx8800 to successfully use 
the tuner.

In the case of FusionHDTV5 pci nano, there will never be an attach call 
from the analog side of the driver, since the tuner is hidden behind the 
s5h1409's i2c gate, and analog mode is not supported with the current 
driver.  If you set i2c_scan=1 on the PCI nano, the xceive tuner will 
not even show up in the scan.

> We need one solution that works for all boards, not just yours.
>
> That's said, maybe SET_TUNER_CONFIG is being called too early. Maybe the
way to
> fix this is to create an special function to initialize it, that would be
> called later by cx8800 or cx8802.
both cx8800 *and* cx8802 need this functionality.  Please keep in mind 
that some users do not ever use analog mode of these cards, and some 
have even blacklisted cx8800 from loading.  This is fine, because cx8800 
is not needed for cx88-dvb to function properly.  This is a level of 
flexibility that we do not want to remove.

The _real_ problem is that the tuner is being attached to the bridge 
driver in two locations -- analog side and digital side.  This problem 
will be entirely avoided once we are attaching the tuner driver in a 
single location, globally to the entire driver.  Such changes are 
planned to be dealt with in tuner refactor phase 4, but I am still 
dealing with refactoring the prerequisites for this scenario, in phase 3 
-- all will come in due time, but for now, we must provide a fully 
qualified attachment call each time we attach a tuner driver.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
