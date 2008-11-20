Return-path: <video4linux-list-bounces@redhat.com>
From: Jean-Francois Moine <moinejf@free.fr>
To: David Ellingsworth <david@identd.dyndns.org>
In-Reply-To: <30353c3d0811201057o2244ca80of033e3bead96c779@mail.gmail.com>
References: <200811151218.45664.m.kozlowski@tuxland.pl>
	<30353c3d0811190552y2ef78b53s833182da377a5046@mail.gmail.com>
	<492439AE.1070903@redhat.com>
	<200811192256.09361.m.kozlowski@tuxland.pl>
	<1227205179.1708.47.camel@localhost>
	<30353c3d0811201057o2244ca80of033e3bead96c779@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 20 Nov 2008 20:03:51 +0100
Message-Id: <1227207831.1708.58.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mariusz Kozlowski <m.kozlowski@tuxland.pl>, video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] [BUG] zc3xx oopses on unplug: unable to
	handle kernel paging request
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

On Thu, 2008-11-20 at 13:57 -0500, David Ellingsworth wrote:
> I'm not entirely sure what's going on in the gspca driver. It seems as
> though the module count is wrong. Unfortunately, I don't have a camera

No, the module count is correct, the problem is that it is incremented /
decremented by 2 at each open / close. Don't you have the same behaviour
with stk-webcam?

> which uses this driver so it's a little hard for me to do any
> debugging with it at this time. Technically though, freeing the
> gspca_dev in the release callback of the video_device struct should be
> possible and that is how it was intended to be used. The stk-webcam
> driver has no issues using it this way either.

I looked at your code, and the only difference I see is that I
increment / decrement explicitly the subdriver module count (OK, step 1
- this module is not the main driver which has the file operations and
the problem!).

Did you activate the slab debug and check the disconnect while
streaming?

Regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
