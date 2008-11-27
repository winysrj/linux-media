Return-path: <video4linux-list-bounces@redhat.com>
Date: Fri, 28 Nov 2008 00:00:05 +0800
From: Chia-I Wu <olvaffe@gmail.com>
To: Erik =?iso-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
Message-ID: <20081127160005.GA4097@m500.domain>
References: <492B15E1.2080207@gmail.com> <20081125082002.GC18787@m500.domain>
	<492E7906.905@redhat.com> <20081127105931.GD19421@m500.domain>
	<62e5edd40811270355id4e856g1a8fb53f73455a39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62e5edd40811270355id4e856g1a8fb53f73455a39@mail.gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>, video4linux-list@redhat.com,
	noodles@earth.li, qce-ga-devel@lists.sourceforge.net
Subject: Re: Please test the gspca-stv06xx branch
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

On Thu, Nov 27, 2008 at 12:55:21PM +0100, Erik Andrén wrote:
> 2008/11/27 Chia-I Wu <olvaffe@gmail.com>:
> > On Thu, Nov 27, 2008 at 11:40:06AM +0100, Hans de Goede wrote:
> >> Chia-I Wu, I'm afraid this might conflict with your HDCS work, as it is
> >> against Erik's latest hg tree, so without your patches. I noticed you
> >> were defining your own read/write register functions which really seems
> >> the wrong thing todo, hopefully with my new functions you can use those
> >> directly, or ?
> > IMO, it is almost always a good thing that each driver defines its own
> > wrapping reg read/write functions.  It is less confusing and saves
> > typings.  It makes the sub-driver loosely coupled with the main driver.
> > And, the compiler will do the right thing, and optimize them out if
> > appropriate.
> I agree with Hans on this matter. It convolutes the driver and gives
> no real gain.
> I've just been converting the gspca-m5602 to use one set of read /
> write functions instead of sensor specific ones and it removes a large
> amount of code.
> What the compiler does is one thing but when dealing with non
> performance critical code paths, code simplicity is more important.
It is the opposite.  What compiler does good to us is that, instead of
macros, one could define functions.

Other than hdcs_reg_write_seq, you may think the others as simple as,
for example,

#define hdcs_reg_write(hdcs, reg, val) \
	stv06xx_write_sensor_b(hdcs->sd, reg, val)

There should be no complication, and the significance here is that it
gives clear implication that there is no word write
(stv06xx_write_sensor_w) to this device, even though it is available in
the stv06xx.h.

IMO, there should be per-sensor I/O functions.  And the implementations
should be as simple as wrappers (i.e., macros) to the generic ones
provided by the bridge.  Sending exotic usb control messages is the job
of the bridge driver, not the sensor driver's.

The purpose for hdcs_reg_write_seq is a little bit trickier.  According
to the datasheet, HDCS family uses a serial protocol, instead of i2c, to
communicate with STV06xx.  When the first bit of HDCS_ICTRL is cleared,
it allows sequential writes: The beginning address is given once,
followed by a set of values.  The address will be automatically
incremented.  The prototype of hdcs_reg_write_seq models this hardware
characteristic, which might be something not shared by every sensor.

-- 
Regards,
olv

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
