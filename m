Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB5HkGgc022793
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 12:46:16 -0500
Received: from carla.brutex.net (carla.brutex.net [85.10.196.13])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mB5HjQYU009512
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 12:45:27 -0500
From: Brian Rosenberger <brian@brutex.de>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0812050822q63d946b8y960559f7bca10e6f@mail.gmail.com>
References: <1228493415.439.8.camel@bru02>
	<412bdbff0812050822q63d946b8y960559f7bca10e6f@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 18:45:24 +0100
Message-Id: <1228499124.2547.6.camel@bru02>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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

Am Freitag, den 05.12.2008, 11:22 -0500 schrieb Devin Heitmueller:

> The error you described occurs when a vendor uses Empia's default USB
> ID and we don't have a profile for the device in the driver (so we
> know things like the correct GPIOs to be set, etc).
> 
> Do you know what tuner chip this device contains?  Which demodulator?
> If not, please open the device and take photos, so we can build a
> device profile.
> [..]
> Regards,
> 
> Devin
> 

Hi Devin,

I opened the stick and found that it is a Pinnacle PCTV USB 70e revision
1.2. I can see two chips on it, a Zarlink ZL10353 and a MT2060F. I don't
know if this will be helpful?

Brian

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
