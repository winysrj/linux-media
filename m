Return-path: <video4linux-list-bounces@redhat.com>
Date: Sun, 4 Jan 2009 13:17:33 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: "Robert Krakora" <rob.krakora@messagenetsystems.com>
Message-ID: <20090104131733.6f80efd6@gmail.com>
In-Reply-To: <b24e53350901031916i51c00cfaq7b75934b2b897b15@mail.gmail.com>
References: <b24e53350812311623qbf8a501re86303fb0fd9ef5c@mail.gmail.com>
	<b24e53350901031059w53da1bb9j54c2e89a4bd0dfed@mail.gmail.com>
	<20090103224351.0276d1d5@gmail.com>
	<b24e53350901031916i51c00cfaq7b75934b2b897b15@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jerry Geis <geisj@messagenetsystems.com>, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: em28xx-audio.c memory leak and kill URB function call missing?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Hello Robert,

On Sat, 3 Jan 2009 22:16:29 -0500
"Robert Krakora" <rob.krakora@messagenetsystems.com> wrote:

> Douglas:
> 
> Sure, I will submit a patch.  However, I notice that other v4l
> drivers call usb_kill_urb().  

Not all, there are drivers in v4l-dvb tree using usb_unlink_urb().

> How can I recall the previous "oops" to
> review the description of the change.  It seems to me that one would
> want to wait for the URB to complete if it is in progress.

http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg02015.html

Cheers
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
