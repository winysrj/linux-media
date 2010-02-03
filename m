Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13JJ7u0010022
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 14:19:07 -0500
Received: from mail-bw0-f217.google.com (mail-bw0-f217.google.com
	[209.85.218.217])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13JIrTC008759
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 14:18:54 -0500
Received: by bwz9 with SMTP id 9so7906bwz.30
	for <video4linux-list@redhat.com>; Wed, 03 Feb 2010 11:18:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <005801caa502$ad686ca0$083945e0$@com>
References: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>
	<829197381002030954j6ebc845fl269e2f72bffbcba@mail.gmail.com>
	<SNT123-W631AD70788CCBA562F2E20EE560@phx.gbl>
	<005801caa502$ad686ca0$083945e0$@com>
Date: Wed, 3 Feb 2010 14:18:51 -0500
Message-ID: <829197381002031118h483cb570ld7177c502ce78298@mail.gmail.com>
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
