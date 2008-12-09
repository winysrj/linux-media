Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9GAfsv008749
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 11:10:41 -0500
Received: from mail1.mxsweep.com (mail152.ix.emailantidote.com
	[89.167.219.152])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mB9GALsK013965
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 11:10:22 -0500
Message-ID: <493E9834.8000908@draigBrady.com>
Date: Tue, 9 Dec 2008 16:09:24 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
References: <1228493415.439.8.camel@bru02>	
	<412bdbff0812050822q63d946b8y960559f7bca10e6f@mail.gmail.com>	
	<1228499124.2547.6.camel@bru02>	
	<412bdbff0812050949s545547d2v92bd3633b76b478e@mail.gmail.com>	
	<1228583227.6281.1.camel@bru02> <493E665B.5040509@draigBrady.com>
	<412bdbff0812090657o3219611x23d67f3c0f790032@mail.gmail.com>
In-Reply-To: <412bdbff0812090657o3219611x23d67f3c0f790032@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
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

Devin Heitmueller wrote:
> On Tue, Dec 9, 2008 at 7:36 AM, Pádraig Brady <P@draigbrady.com> wrote:
>> Brian Rosenberger wrote:
>>> Am Freitag, den 05.12.2008, 12:49 -0500 schrieb Devin Heitmueller:
>>>
>>>> Yes, that's exactly what I needed to know.  If you can get the Windows
>>>> USB trace, we should be able to extract the GPIOs from that and add
>>>> the device support.
>> Isn't that card already supported here?
>> http://mcentral.de/hg/~mrec/em28xx-new/file/3fe18e8981e5/em28xx-cards.c
>>
>> I'm worried that there is more duplication of work now happening,
>> and things are going to get even more out of sync.
> 
> I don't know if Markus's tree supports this device but it wouldn't
> surprise me if it did.
> 
>> Devin, perhaps you could help with merging Markus' driver into mainline?
> 
> Yeah, this is a really crappy situation.  Markus has made very clear
> that he doesn't want his changes merged into the mainline driver.  The
> only solution he is willing to accept is for his driver to be put in
> alongside the mainline driver in its entirety, which has been
> considered unacceptable for a variety of good reasons.

Hmm. Is there anything supported by the mainline driver
that's not supported by Markus' driver?

If not, then perhaps the pragmatic solution is to put markus' driver
in parallel and deprecate the existing one, like was done
with the e100 and eepro100 for example?

I think that would benefit all users immediately,
and developers can sort out the merging/removal later.

thanks,
Pádraig.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
