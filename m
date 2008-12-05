Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB5HoAVo024366
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 12:50:10 -0500
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.239])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB5HnfN2012328
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 12:49:41 -0500
Received: by qb-out-0506.google.com with SMTP id c8so90758qbc.7
	for <video4linux-list@redhat.com>; Fri, 05 Dec 2008 09:49:40 -0800 (PST)
Message-ID: <412bdbff0812050949s545547d2v92bd3633b76b478e@mail.gmail.com>
Date: Fri, 5 Dec 2008 12:49:40 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Brian Rosenberger" <brian@brutex.de>
In-Reply-To: <1228499124.2547.6.camel@bru02>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228493415.439.8.camel@bru02>
	<412bdbff0812050822q63d946b8y960559f7bca10e6f@mail.gmail.com>
	<1228499124.2547.6.camel@bru02>
Cc: video4linux-list@redhat.com
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

On Fri, Dec 5, 2008 at 12:45 PM, Brian Rosenberger <brian@brutex.de> wrote:
> Am Freitag, den 05.12.2008, 11:22 -0500 schrieb Devin Heitmueller:
>
>> The error you described occurs when a vendor uses Empia's default USB
>> ID and we don't have a profile for the device in the driver (so we
>> know things like the correct GPIOs to be set, etc).
>>
>> Do you know what tuner chip this device contains?  Which demodulator?
>> If not, please open the device and take photos, so we can build a
>> device profile.
>> [..]
>> Regards,
>>
>> Devin
>>
>
> Hi Devin,
>
> I opened the stick and found that it is a Pinnacle PCTV USB 70e revision
> 1.2. I can see two chips on it, a Zarlink ZL10353 and a MT2060F. I don't
> know if this will be helpful?

Yes, that's exactly what I needed to know.  If you can get the Windows
USB trace, we should be able to extract the GPIOs from that and add
the device support.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
