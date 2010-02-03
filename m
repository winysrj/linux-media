Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13KCmsC011002
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 15:12:48 -0500
Received: from mail-bw0-f217.google.com (mail-bw0-f217.google.com
	[209.85.218.217])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13KCZZ3002294
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 15:12:35 -0500
Received: by bwz9 with SMTP id 9so68856bwz.30
	for <video4linux-list@redhat.com>; Wed, 03 Feb 2010 12:12:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <006001caa50b$b00fa8c0$102efa40$@com>
References: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>
	<829197381002030954j6ebc845fl269e2f72bffbcba@mail.gmail.com>
	<SNT123-W631AD70788CCBA562F2E20EE560@phx.gbl>
	<005801caa502$ad686ca0$083945e0$@com>
	<829197381002031118h483cb570ld7177c502ce78298@mail.gmail.com>
	<006001caa50b$b00fa8c0$102efa40$@com>
Date: Wed, 3 Feb 2010 15:12:33 -0500
Message-ID: <829197381002031212w317346b3of4754f2be12f5fbd@mail.gmail.com>
Subject: Re: Saving YUVY image from V4L2 buffer to file
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Charlie X. Liu" <charlie@sensoray.com>
Cc: "Owen O' Hehir" <oo_hehir@hotmail.com>, video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, Feb 3, 2010 at 3:01 PM, Charlie X. Liu <charlie@sensoray.com> wrote:
> Do most of Webcams have no RGB support? I'm not experienced on that. Does
> anybody know the percentage of RGB support by Webcams?

Well, the V4L interface doesn't make the distinction between webcams
and other analog capture devices.  That said, webcams do tend to
provide some variant of RGB (and in a number of cases it uses
proprietary formats that include compression that must be handled in
userland).  So there are different formats that would all be
considered some form of RGB.

Other capture devices, such as tuners and home movie converters tend to use YUV.

So, if you're looking to write a simple app for internal use to work
with a particular webcam, you can disregard the above.  But if you are
trying to write a generic capture application that is expected to work
with many products, then you need to take into consideration all the
different formats that can be used.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
