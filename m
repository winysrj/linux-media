Return-path: <video4linux-list-bounces@redhat.com>
Date: Thu, 27 Nov 2008 18:59:32 +0800
From: Chia-I Wu <olvaffe@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Message-ID: <20081127105931.GD19421@m500.domain>
References: <492B15E1.2080207@gmail.com> <20081125082002.GC18787@m500.domain>
	<492E7906.905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492E7906.905@redhat.com>
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

On Thu, Nov 27, 2008 at 11:40:06AM +0100, Hans de Goede wrote:
> Chia-I Wu, I'm afraid this might conflict with your HDCS work, as it is 
> against Erik's latest hg tree, so without your patches. I noticed you 
> were defining your own read/write register functions which really seems 
> the wrong thing todo, hopefully with my new functions you can use those 
> directly, or ?
IMO, it is almost always a good thing that each driver defines its own
wrapping reg read/write functions.  It is less confusing and saves
typings.  It makes the sub-driver loosely coupled with the main driver.
And, the compiler will do the right thing, and optimize them out if
appropriate.

-- 
Regards,
olv

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
