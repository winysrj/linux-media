Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpgw01.world4you.com ([80.243.163.21])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <treitmayr@devbase.at>) id 1JqEDv-0003Ry-Lf
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 23:15:53 +0200
Received: from [85.127.158.184] (helo=[192.168.1.76])
	by smtpgw01.world4you.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67) (envelope-from <treitmayr@devbase.at>)
	id 1JqEDr-00074N-42
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 23:15:47 +0200
From: Thomas Reitmayr <treitmayr@devbase.at>
To: linux-dvb@linuxtv.org
Date: Sun, 27 Apr 2008 23:15:46 +0200
Message-Id: <1209330946.6897.2.camel@localhost>
Mime-Version: 1.0
Subject: Re: [linux-dvb] NSLU2 dma_free_coherent issue with DIB0700
	driver	(and probably others)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Lee,
I was browsing the mailing-list archive and found your email about the
issue with DIB0700-based devices on an NSLU2. I myself use a Terratec
Cinergy DT XS Diversity which I think had the same issue as you
described it. I found that the cause was the rather big DMA buffer of
39480 bytes as specified in dib0700_devices.c.
Looking at the kernel's arch/arm/mach-ixp4xx/common-pci.c there is a top
limit of 4096 bytes for a DMA buffer set by the function call 
   dmabounce_register_dev(dev, 2048, 4096);

My recipe (for SlugOS) below changes the big buffer to a smaller one and
also increases the number of buffers (not sure if the latter is really
needed). Now the module is working just fine, even recording on both
adapters gives a CPU usage of just ~25%. So the smaller buffer size does
not seem to hurt at all. Not sure why it is needed in the first place.

Bye,
-Thomas


PS: My recipe "v4l-dvb_0776e4801991.bb"

========= CUT ==========

DESCRIPTION = "v4l-dvb modules"
#SECTION = ""
PRIORITY = "optional"
HOMEPAGE = "http://linuxtv.org/"
LICENSE = "GPL"
DEPENDS = "virtual/kernel"
PR = "r0"

SRC_URI = "http://linuxtv.org/hg/v4l-dvb/archive/${PV}.tar.bz2"

S = "${WORKDIR}/${PN}-${PV}"

inherit module

MAKE_TARGETS = "DIR=${STAGING_KERNEL_DIR}"

do_configure() {
	# fix make target
	cd "${S}"
	sed -i 's%^install:%install modules_install:%' Makefile
	
	# reduce buffer size (ixp4xx can handle only <= 4096
	# (see arch/arm/mach-ixp4xx/common-pci.c)
	cd "${S}/linux/drivers/media/dvb/dvb-usb"
	sed -i 's%buffersize = 39480%buffersize = 4096%' dib0700_devices.c
	sed -i 's%\.count = 4,%.count = 7,%' dib0700_devices.c
	
	# do not strip here
	cd "${S}/v4l/scripts"
	sed -i 's%@strip %@#strip %' make_makefile.pl
}

fakeroot do_install() {
	oe_runmake DESTDIR="${D}" install
}

FILES_${PN} = "/lib/modules"

========= CUT ==========


        ---- Original Message ----
        From: Lee Essen lee.essen at nowonline.co.uk 
        Date: Thu Apr 3 12:48:05 CEST 2008
        
        Hi,
        
        Apologies if this is directed in the wrong place, as I suspect
        this is more of a kernel/USB issue than a DVB driver issue, but
        it does have an impact on people wanting to use this device with
        an NSLU2 (and I suspect it will also be a problem with many
        other devices.)
        
        I have been experimenting using a variety of DVB-T USB devices
        with an NSLU2 with my ultimate aim being to build in a dual
        DVB-T device into the case and use it in very much the same way
        as the HDHomeRun device.
        
        Using a DTT200U based device everything worked perfectly.
        
        Then I started playing with a DIB0700 based device (actually an
        Elgato Eye-TV Diversity) and the system would just hang whenever
        I started using dvbstream, I got slightly different behaviour if
        I tried to tune it to an invalid frequency and eventually
        managed to get to a state when I could interrupt it before it
        completely locked up.
        
        It seems that the driver was flagging an issue in the ARM
        architecture around not calling dma_free_coherent() with IRQ's
        disabled, apparently a warning was recently added to the ARM
        kernel so it logs a message and a stack trace each time ... this
        seemed to be happening so frequently it effectively locked the
        system up.
        
        I did a little digging, but I'm not a kernel expert at all, and
        it seems that the ehci_hcd module is actually where the call is
        originating rather than the DVB driver itself, so I suspect that
        this will actually effect a significant number of the drivers
        when used on an ARM platform.
        
        For the purposes of testing I removed the warning (from
        arch/arm/mm/ consistent line 363) and everything is fine, the
        driver operates perfectly and I can stream video nicely. BUT -
        clearly there is some kind of issue here that needs to be
        resolved.
        
        More information is available at the link below, and also I have
        read comments suggesting that the issue has been discussed on
        the arm-kernel mailing list but that no resolution has yet been
        found.
        
        http://forum.soft32.com/linux/ehci_hcd-map_single-unable-map-unsafe-buffer-standard-NSLU2-ftopict461241.html
        
        For reference I'm using 2.6.24 and have tried the most recent
        drivers from linuxtv.org as well as a variety of others -- all
        seem to have the same problem (which is expected if the problem
        is actually in the USB system.)
        
        Hope this is useful,
        
        Lee.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
