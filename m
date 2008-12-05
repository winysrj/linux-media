Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB5GMT1E004463
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 11:22:29 -0500
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB5GMBMc026408
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 11:22:11 -0500
Received: by qb-out-0506.google.com with SMTP id c8so58772qbc.7
	for <video4linux-list@redhat.com>; Fri, 05 Dec 2008 08:22:11 -0800 (PST)
Message-ID: <412bdbff0812050822q63d946b8y960559f7bca10e6f@mail.gmail.com>
Date: Fri, 5 Dec 2008 11:22:10 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Brian Rosenberger" <brian@brutex.de>
In-Reply-To: <1228493415.439.8.camel@bru02>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228493415.439.8.camel@bru02>
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

On Fri, Dec 5, 2008 at 11:10 AM, Brian Rosenberger <brian@brutex.de> wrote:
> Hi,
>
> I am trying to get my Pinnacle PCTV USB (DVB-T device [eb1a:2870]) to
> work. I fetched sources from http://linuxtv.org/hg/v4l-dvb and then did
> a make, make install and make load. Everything went fine as far my
> understanding is (yes with reboot in between).
> Next I plugged the usb stick and checked dmesg (see below). I am a bit
> stuck right now, I did try some card=xx variants, but /dev/dvb isn't
> created.
>
> What are the next steps?
>
> Thanks
> Brian
>

The error you described occurs when a vendor uses Empia's default USB
ID and we don't have a profile for the device in the driver (so we
know things like the correct GPIOs to be set, etc).

Do you know what tuner chip this device contains?  Which demodulator?
If not, please open the device and take photos, so we can build a
device profile.

Secondly, we need to know what GPIO mapping is needed.  If you could
please get a USB capture using "SniffUSB 2.0" for Windows after
opening the TV application, we should be able to get this device
working under Linux.

I would recommend you figure out what demod/tuner it has first before
doing the Windows USB trace.  This will allow us to confirm that the
demod and tuner drivers are available before you go through the work
of getting the Windows trace.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
