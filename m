Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (ext-mx01.rdu.redhat.com [10.11.45.6])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2DILPgw008299
	for <video4linux-list@redhat.com>; Sat, 13 Mar 2010 13:21:25 -0500
Received: from web34408.mail.mud.yahoo.com (web34408.mail.mud.yahoo.com
	[66.163.178.157])
	by mx2.redhat.com (8.13.8/8.13.8) with SMTP id o2DILOTT021401
	for <video4linux-list@redhat.com>; Sat, 13 Mar 2010 13:21:24 -0500
Message-ID: <701703.28465.qm@web34408.mail.mud.yahoo.com>
References: <737952.62741.qm@web34405.mail.mud.yahoo.com>
	<829197381003130931m4b3c0d3doa17cb57cea70b62@mail.gmail.com>
Date: Sat, 13 Mar 2010 10:14:43 -0800 (PST)
From: Muppet Man <muppetman4662@yahoo.com>
Subject: Re: support for hauppauge wintv-hvr 950Q
To: Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <829197381003130931m4b3c0d3doa17cb57cea70b62@mail.gmail.com>
MIME-Version: 1.0
Cc: video4linux-list@redhat.com
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

Greetings,
Yes, I rebooted after installing the code.  I do see the device now, but it was odd because I did not see it before (and I rebooted numerous times).
Thanks!



________________________________
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Muppet Man <muppetman4662@yahoo.com>
Cc: video4linux-list@redhat.com
Sent: Sat, March 13, 2010 11:31:30 AM
Subject: Re: support for hauppauge wintv-hvr 950Q

On Sat, Mar 13, 2010 at 11:50 AM, Muppet Man <muppetman4662@yahoo.com> wrote:
> Greetings all,
> I purchased a hauppauge wintv-hvr 950Q.  I downloaded and installed the lastest drivers from the v4l website.
>
> When attempting to use with TVtime, the only "video" device I can find is my webcam.
> When running lsusb, this is what I get:

Hello,

Did you reboot after installing the code?  Did you install the code
using the instructions at http://linuxtv.org/repo?

After the device is plugged in, you should see a new /dev/video device
appear.  If not, then the driver did not load.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com



      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
