Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab3BINls (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Feb 2013 08:41:48 -0500
Date: Sat, 9 Feb 2013 11:41:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <rob.herring@calxeda.com>,
	Rob Landley <rob@landley.net>,
	Benoit Thebaudeau <benoit.thebaudeau@advansee.com>,
	David Hardeman <david@hardeman.nu>,
	Trilok Soni <tsoni@codeaurora.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Matus Ujhelyi <ujhelyi.m@gmail.com>,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] media: rc: gpio-ir-recv: add support for device tree
 parsing
Message-ID: <20130209114119.39a09d67@redhat.com>
In-Reply-To: <51159C36.1060602@gmail.com>
References: <1360137832-13086-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1360355887-19973-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130208220357.198c313c@redhat.com>
	<51159C36.1060602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 09 Feb 2013 01:45:42 +0100
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> escreveu:

> On 02/09/2013 01:03 AM, Mauro Carvalho Chehab wrote:
> > Em Fri,  8 Feb 2013 21:38:07 +0100
> > Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>  escreveu:
> >
> >> This patch adds device tree parsing for gpio_ir_recv platform_data and
> >> the mandatory binding documentation. It basically follows what we already
> >> have for e.g. gpio_keys. All required device tree properties are OS
> >> independent but an optional property allow linux specific support for rc
> >> maps.
> >>
> >> There was a similar patch sent by Matus Ujhelyi but that discussion
> >> died after the first reviews.
> >>
> >> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> >> ---
> >> Changelog
> >>
> >> v1->v2:
> >> - get rid of ptr returned by _get_devtree_pdata()
> >> - check for of_node instead for NULL pdata
> >> - remove unneccessary double check for gpios property
> >> - remove unneccessary #ifdef CONFIG_OF around match table
> >>
> >> Cc: Grant Likely<grant.likely@secretlab.ca>
> >> Cc: Rob Herring<rob.herring@calxeda.com>
> >> Cc: Rob Landley<rob@landley.net>
> >> Cc: Mauro Carvalho Chehab<mchehab@redhat.com>
> >> Cc: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> >> Cc: Benoit Thebaudeau<benoit.thebaudeau@advansee.com>
> >> Cc: David Hardeman<david@hardeman.nu>
> >> Cc: Trilok Soni<tsoni@codeaurora.org>
> >> Cc: Sylwester Nawrocki<s.nawrocki@samsung.com>
> >> Cc: Matus Ujhelyi<ujhelyi.m@gmail.com>
> >> Cc: devicetree-discuss@lists.ozlabs.org
> >> Cc: linux-doc@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: linux-media@vger.kernel.org
> >> ---
> >>   .../devicetree/bindings/media/gpio-ir-receiver.txt |   16 ++++++
> >>   drivers/media/rc/gpio-ir-recv.c                    |   57 ++++++++++++++++++++
> >>   2 files changed, 73 insertions(+)
> >>   create mode 100644 Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
> >> new file mode 100644
> >> index 0000000..8589f30
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
> >> @@ -0,0 +1,16 @@
> >> +Device-Tree bindings for GPIO IR receiver
> >> +
> >> +Required properties:
> >> +	- compatible = "gpio-ir-receiver";
> >> +	- gpios: OF device-tree gpio specification.
> >> +
> >> +Optional properties:
> >> +	- linux,rc-map-name: Linux specific remote control map name.
> >> +
> >> +Example node:
> >> +
> >> +	ir: ir-receiver {
> >> +		compatible = "gpio-ir-receiver";
> >> +		gpios =<&gpio0 19 1>;
> >> +		linux,rc-map-name = "rc-rc6-mce";
> >
> > Please change this to:
> > 		linux,rc-map-name = RC_MAP_RC6_MCE;
> >
> > (as defined at include/media/rc-map.h).
> 
> Mauro,
> 
> this is not possible in device tree bindings. Device tree properties
> can only carry numeric or string types (and some other stuff) but no
> OS specific enumerations. So using strings is the only option here.
> 
> > The idea of having those strings defined at the same header file is to:
> 
> Unfortunately, device tree blobs don't know about linux header files.
> 
> That leaves two options:
> - allow the user to supply a string of the map in his device tree description
>    and risk that there may be a broken map name
> - remove linux,rc-map-name from DT binding and let the user configure in
>    from user space (which is propably best choice anyway)
> 
> I tried both, DT supplied map name and ir-keytable from userspace
> both work fine.

IMO, the first option is better, e. g. letting the device tree have the
string there.

Regards,
Mauro
