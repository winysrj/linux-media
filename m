Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:10273 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751659AbeCOLlt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 07:41:49 -0400
Date: Thu, 15 Mar 2018 13:41:46 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: =?iso-8859-1?Q?FR=C9D=C9RIC?= PARRENIN
        <frederic.parrenin@univ-grenoble-alpes.fr>,
        Oliver Neukum <oneukum@suse.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Webcams not recognized on a Dell Latitude 5285 laptop
Message-ID: <20180315114146.4qlfnxp3hc27oy4z@paasikivi.fi.intel.com>
References: <382b6f23-d36e-696a-a536-bb5c05b10d34@univ-grenoble-alpes.fr>
 <1512989520.22920.2.camel@suse.com>
 <1607480650.971508.1513000904833.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <1513002580.22920.15.camel@suse.com>
 <1599416013.1022922.1513002815596.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <1513004631.22920.20.camel@suse.com>
 <1847654838.1115072.1513006781751.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <871008484.8702062.1520771930968.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <CAHp75Vf0EWNzn+aRrg8XRZpKvmNMq=OXmLiW5FVGx+20xTvDuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75Vf0EWNzn+aRrg8XRZpKvmNMq=OXmLiW5FVGx+20xTvDuw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy and Frédéric,

On Tue, Mar 13, 2018 at 06:11:00PM +0200, Andy Shevchenko wrote:
> On Sun, Mar 11, 2018 at 2:38 PM, FRÉDÉRIC PARRENIN
> <frederic.parrenin@univ-grenoble-alpes.fr> wrote:
> > Dear Oliver and all,
> >
> > So I was expecting linux-4.16 to recognize my webcams, thanks to this new PCI driver Oliver mentioned.
> > Therefore I installed 4.16-rc4.
> > Unfortunately, there is still no /dev/video* device
> >
> > Any idea what could be done to have these webcams working?
> 
> I guess you need a driver.
> Cc: + Sakari, and thus leaving the complete message uncut.

Or drivers. And a bit more than that actually. Assuming this is IPU3, that
is. If that's the case, the short answer is there's no trivial way to
support webcam-like functionality using this device. The ACPI tables would
tell more details.

Could you send me the ACPI tables, i.e. the file produced by the command:

	acpidump -o acpidump.bin

In Debian acpidump is included in acpica-tools package.

Thank you.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
