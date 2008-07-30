Return-path: <video4linux-list-bounces@redhat.com>
Date: Wed, 30 Jul 2008 12:07:48 -0400
From: Alan Cox <alan@redhat.com>
To: Fritz Katz <frtzkatz@yahoo.com>
Message-ID: <20080730160748.GA6695@devserv.devel.redhat.com>
References: <840865.6007.qm@web63010.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <840865.6007.qm@web63010.mail.re1.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: What info does V-4-L expect to be in the "Identifier EEprom"?
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

On Wed, Jul 30, 2008 at 08:54:36AM -0700, Fritz Katz wrote:
> I'm a consultant for a company that wishes to produce a video cards that will run Video-4-Linux applications. The company currently produces tuners and video capture cards for Microsoft Windows.
> 
> The company wishes to include an "Identifier EEprom" on the board so V4L will 
> recognize the card and load appropriate drivers at boot-up.
> 
> Please point me in the direction of documentation for the info V4L expects to 
> be found in the ID eeprom.

This depends on the chipset. The kernel matches drivers generally by using the
PCI class code, PCI vendor/device and PCI subvendor/device. For some video
capture devices multiple vendors shipped different devices with no real
distinguishing features except internal eeprom detail.

Peering into eeproms to tell them apart is generally a last resort and if there
are unique subvendor/devicd identifiers for your card that should be all you
need except to add entries to the relevant device driver indicating the relevant
GPIO pins/tuner etc for board specific stuff.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
