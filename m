Return-path: <video4linux-list-bounces@redhat.com>
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <492439AE.1070903@redhat.com>
References: <200811151218.45664.m.kozlowski@tuxland.pl>
	<200811162224.47885.m.kozlowski@tuxland.pl>
	<1227034668.1703.4.camel@localhost>
	<200811182219.38925.m.kozlowski@tuxland.pl>
	<1227090732.2998.8.camel@localhost>
	<30353c3d0811190552y2ef78b53s833182da377a5046@mail.gmail.com>
	<492439AE.1070903@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 19 Nov 2008 21:20:29 +0100
Message-Id: <1227126029.1709.42.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	David Ellingsworth <david@identd.dyndns.org>,
	Mariusz Kozlowski <m.kozlowski@tuxland.pl>
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

On Wed, 2008-11-19 at 17:07 +0100, Hans de Goede wrote:
> Here is a patch fixing this by using the ref counting already built
> into the 
> v4l2-core. Jean-Francois, this is to be applied after reverting your
> fix for this.

Done.

Thanks.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
