Return-path: <video4linux-list-bounces@redhat.com>
Date: Fri, 28 Nov 2008 12:26:32 +0800
From: Chia-I Wu <olvaffe@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Message-ID: <20081128042632.GA15343@m500.domain>
References: <492B15E1.2080207@gmail.com> <20081125082002.GC18787@m500.domain>
	<492E7906.905@redhat.com> <20081127105931.GD19421@m500.domain>
	<62e5edd40811270355id4e856g1a8fb53f73455a39@mail.gmail.com>
	<20081127160005.GA4097@m500.domain> <492EE597.7010100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492EE597.7010100@redhat.com>
Cc: video4linux-list@redhat.com, noodles@earth.li,
	qce-ga-devel@lists.sourceforge.net
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

On Thu, Nov 27, 2008 at 07:23:19PM +0100, Hans de Goede wrote:
> Exactly, so the functions belong in the bridge code, and if those 
> functions are properly written and prototyped, then they should be 
> directly usable from the sensor without requiring convoluting macros 
> around them. The only reason and acceptable use I see for using macro's 
> here would be to simplify the error handling as is currently done in the 
> other 2 sensor code files.
Each sensor could have a slightly different way to access the registers.
The bridge is responsible to provide means to ease the work needed in
the sensor drivers.

When 046d:0850 tries to write to its registers, it could

* have a wrapper which calls the helper function _AND_ write to reg
  0x1704 of the bridge (the extra packet).  Or,
* simply call the helper function.  The helper function checks the
  product id and send a second control message automatically.

I see the logics belong to the sensor driver and prefer the first
method, while you might see the second method easier to use.

My point is, a wrapper is not a big *NO*.  Instead, it is a good
practice, even if there is no sensor-specific logics involved.
> I greatly appreciate your efforts, but please try to constrain yourself 
> the programming model / pragma's followed through out gspca.
I would like to rebase the patch against current tip, or your changes
once they are merged.

-- 
Regards,
olv

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
