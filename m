Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0NDsh3G028024
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 08:54:43 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0NDsPZK023254
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 08:54:25 -0500
Received: by qw-out-2122.google.com with SMTP id 3so917660qwe.39
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 05:54:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232716272588-2203202.post@n2.nabble.com>
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
	<412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
	<alpine.DEB.1.10.0811262054050.10867@bakacsin.ki.iif.hu>
	<412bdbff0811261226l478e3d4eg2f0551239e56540a@mail.gmail.com>
	<alpine.DEB.1.10.0811262158020.10867@bakacsin.ki.iif.hu>
	<412bdbff0811261343m32021a70ia5a1e3541233c2bd@mail.gmail.com>
	<alpine.DEB.1.10.0811262251210.10867@bakacsin.ki.iif.hu>
	<412bdbff0811261402s2cf5d965xc5dc60325f5a95ec@mail.gmail.com>
	<1232716272588-2203202.post@n2.nabble.com>
Date: Fri, 23 Jan 2009 08:54:24 -0500
Message-ID: <412bdbff0901230554s2348b9b9m936441d405a62609@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: RobM <robmaurer@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [video4linux] Attention em28xx users
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

On Fri, Jan 23, 2009 at 8:11 AM, RobM <robmaurer@gmail.com> wrote:
>
> Hi Mr. Devin,
> I have the aforementioned ADS Instant TV USB (Model USBAV-704N). It's doing
> me little good at the moment as like Gabor I cannot make it work. If you are
> still interested in having it shipped to you for a bit of inspection/testing
> I am happy to loan it to you.
> Best regards,
> Rob (Massachusetts, USA)

Hello Rob,

I actually have a repository that has this device mostly working for
Gabor - there is still a detection bug that causes it to sometimes not
get initialized properly:

http://linuxtv.org/hg/~dheitmueller/v4l-dvb-newdevices/

It's important to recognize though that Gabor's device has a PAL
tuner, whereas your device most likely has an NTSC tuner.  If you open
the device and take hires photos, we can confirm which tuner the
device actually has.

It would be ideal if you could send me the device.  Unfortunately
though, right now I already have several devices in my queue already
that are taking up all of my time, so I am not currently accepting
more hardware.  Yup, who thought I would reach the point where I would
be turning away hardware!

If you ping me in a few weeks, perhaps I will have some cycles at that point.

Thank you,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
