Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9GGfxW012554
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 11:16:41 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9GFX8P006667
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 11:15:33 -0500
Received: by ewy14 with SMTP id 14so5534ewy.3
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 08:15:33 -0800 (PST)
Message-ID: <412bdbff0812090815q48c7015dwc4ea147fb7ef80de@mail.gmail.com>
Date: Tue, 9 Dec 2008 11:15:32 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "=?ISO-8859-1?Q?P=E1draig_Brady?=" <P@draigbrady.com>
In-Reply-To: <493E9834.8000908@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1228493415.439.8.camel@bru02>
	<412bdbff0812050822q63d946b8y960559f7bca10e6f@mail.gmail.com>
	<1228499124.2547.6.camel@bru02>
	<412bdbff0812050949s545547d2v92bd3633b76b478e@mail.gmail.com>
	<1228583227.6281.1.camel@bru02> <493E665B.5040509@draigBrady.com>
	<412bdbff0812090657o3219611x23d67f3c0f790032@mail.gmail.com>
	<493E9834.8000908@draigBrady.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, Brian Rosenberger <brian@brutex.de>
Subject: Re: Pinnacle PCTV USB (DVB-T device [eb1a:2870])
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

On Tue, Dec 9, 2008 at 11:09 AM, Pádraig Brady <P@draigbrady.com> wrote:
> Devin Heitmueller wrote:
>> On Tue, Dec 9, 2008 at 7:36 AM, Pádraig Brady <P@draigbrady.com> wrote:
>>> Brian Rosenberger wrote:
>>>> Am Freitag, den 05.12.2008, 12:49 -0500 schrieb Devin Heitmueller:
>>>>
>>>>> Yes, that's exactly what I needed to know.  If you can get the Windows
>>>>> USB trace, we should be able to extract the GPIOs from that and add
>>>>> the device support.
>>> Isn't that card already supported here?
>>> http://mcentral.de/hg/~mrec/em28xx-new/file/3fe18e8981e5/em28xx-cards.c
>>>
>>> I'm worried that there is more duplication of work now happening,
>>> and things are going to get even more out of sync.
>>
>> I don't know if Markus's tree supports this device but it wouldn't
>> surprise me if it did.
>>
>>> Devin, perhaps you could help with merging Markus' driver into mainline?
>>
>> Yeah, this is a really crappy situation.  Markus has made very clear
>> that he doesn't want his changes merged into the mainline driver.  The
>> only solution he is willing to accept is for his driver to be put in
>> alongside the mainline driver in its entirety, which has been
>> considered unacceptable for a variety of good reasons.
>
> Hmm. Is there anything supported by the mainline driver
> that's not supported by Markus' driver?
>
> If not, then perhaps the pragmatic solution is to put markus' driver
> in parallel and deprecate the existing one, like was done
> with the e100 and eepro100 for example?
>
> I think that would benefit all users immediately,
> and developers can sort out the merging/removal later.

Yes, there is functionality in the mainline driver that is not in
Markus's driver.  The mainline driver is actively maintained and
continuing to add new capabilities and device support.

This topic has been discussed extensively a number of times in the
past.  Please review the mailing list archives since I really don't
want to start another flamewar over this.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
