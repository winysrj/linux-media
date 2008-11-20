Return-path: <video4linux-list-bounces@redhat.com>
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <200811192256.09361.m.kozlowski@tuxland.pl>
References: <200811151218.45664.m.kozlowski@tuxland.pl>
	<30353c3d0811190552y2ef78b53s833182da377a5046@mail.gmail.com>
	<492439AE.1070903@redhat.com>
	<200811192256.09361.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 20 Nov 2008 19:19:39 +0100
Message-Id: <1227205179.1708.47.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
	David Ellingsworth <david@identd.dyndns.org>, video4linux-list@redhat.com
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

On Wed, 2008-11-19 at 22:56 +0100, Mariusz Kozlowski wrote:
> > Here is a patch fixing this by using the ref counting already built
> > into the 
> > v4l2-core. Jean-Francois, this is to be applied after reverting your
> > fix for this.
> 
> Not sure I understand what should be applied where. I applied your -
> Hans - patch to
> 2.6.28-rc5-00117-g7f0f598. As you see my HEAD in linux-2.6 is at
> 7f0f598a0069d1ab072375965a4b69137233169c and I can reproduce the oops
> easily.
> I turned on all possible debuging in gspca as well. If it should be
> applied to
> some other tree which contains some more fixes for this - my fault.
> Please let me know.

Hi Hans (de Goede) and Hans (Verkuil),

As you saw, the patch does not work.

Looking at the modules, when a webcam is streaming, the module refcount
of the gspca_main is 3: 1 for the subdriver dependancies, and 2 for one
open. Why 2?

I did not look carefully at the I/O system, but it seems there are two
objects / operations associated to the device. When a disconnection
occurs while the device is opened, at close time, there is:
- a first object put of the device which makes it to be released,
- this release should do a first module_put and then
- calls the gspca_release (see the patch) which frees the gspca device
  (and also the video device which is embedded),
- then, the close job is not finished: a second module_put is called
  with the fops of the device,
- as this one is in a non allocated memory and as the slab debug is
  active: oops!

All this is may be found in the function __fput of fs/file_table.c.

I was wondering if the gspca device could not be freed by the release of
the video device, i.e. what happens if there is no 'kfree(gspca_dev)' in
the gspca_release()?

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
