Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13K1qaJ030594
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 15:01:52 -0500
Received: from gateway10.websitewelcome.com (gateway10.websitewelcome.com
	[70.85.130.6])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o13K1ZJG019797
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 15:01:35 -0500
From: "Charlie X. Liu" <charlie@sensoray.com>
To: "'Devin Heitmueller'" <dheitmueller@kernellabs.com>
References: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>	
	<829197381002030954j6ebc845fl269e2f72bffbcba@mail.gmail.com>	
	<SNT123-W631AD70788CCBA562F2E20EE560@phx.gbl>	
	<005801caa502$ad686ca0$083945e0$@com>
	<829197381002031118h483cb570ld7177c502ce78298@mail.gmail.com>
In-Reply-To: <829197381002031118h483cb570ld7177c502ce78298@mail.gmail.com>
Subject: RE: Saving YUVY image from V4L2 buffer to file
Date: Wed, 3 Feb 2010 12:01:33 -0800
Message-ID: <006001caa50b$b00fa8c0$102efa40$@com>
MIME-Version: 1.0
Content-Language: en-us
Cc: "'Owen O' Hehir'" <oo_hehir@hotmail.com>, video4linux-list@redhat.com
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

Do most of Webcams have no RGB support? I'm not experienced on that. Does
anybody know the percentage of RGB support by Webcams?


-----Original Message-----
From: Devin Heitmueller [mailto:dheitmueller@kernellabs.com] 
Sent: Wednesday, February 03, 2010 11:19 AM
To: Charlie X. Liu
Cc: Owen O' Hehir; video4linux-list@redhat.com
Subject: Re: Saving YUVY image from V4L2 buffer to file

On Wed, Feb 3, 2010 at 1:57 PM, Charlie X. Liu <charlie@sensoray.com> wrote:
> Why don't you directly set it with: fmt.fmt.pix.pixelformat =
> V4L2_PIX_FMT_BGR24, instead of converting?

That only really works if the hardware supports providing RGB data as
opposed to YUYV (which many do not).  Or, it would work if you link
against libv4l to do the conversion in userland.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
