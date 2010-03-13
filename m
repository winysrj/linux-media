Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2DHVh9E017201
	for <video4linux-list@redhat.com>; Sat, 13 Mar 2010 12:31:44 -0500
Received: from mail-bw0-f225.google.com (mail-bw0-f225.google.com
	[209.85.218.225])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2DHVVa6011735
	for <video4linux-list@redhat.com>; Sat, 13 Mar 2010 12:31:31 -0500
Received: by bwz25 with SMTP id 25so1921340bwz.11
	for <video4linux-list@redhat.com>; Sat, 13 Mar 2010 09:31:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <737952.62741.qm@web34405.mail.mud.yahoo.com>
References: <737952.62741.qm@web34405.mail.mud.yahoo.com>
Date: Sat, 13 Mar 2010 12:31:30 -0500
Message-ID: <829197381003130931m4b3c0d3doa17cb57cea70b62@mail.gmail.com>
Subject: Re: support for hauppauge wintv-hvr 950Q
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Muppet Man <muppetman4662@yahoo.com>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, Mar 13, 2010 at 11:50 AM, Muppet Man <muppetman4662@yahoo.com> wrot=
e:
> Greetings all,
> I purchased a hauppauge wintv-hvr 950Q. =A0I downloaded and installed the=
 lastest drivers from the v4l website.
>
> When attempting to use with TVtime, the only "video" device I can find is=
 my webcam.
> When running lsusb, this is what I get:

Hello,

Did you reboot after installing the code?  Did you install the code
using the instructions at http://linuxtv.org/repo?

After the device is plugged in, you should see a new /dev/video device
appear.  If not, then the driver did not load.

Devin

-- =

Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
