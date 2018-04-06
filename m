Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54012 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751442AbeDFWLY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 18:11:24 -0400
Date: Sat, 7 Apr 2018 01:11:20 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: =?iso-8859-1?Q?FR=C9D=C9RIC?= PARRENIN
        <frederic.parrenin@univ-grenoble-alpes.fr>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: Webcams not recognized on a Dell Latitude 5285 laptop
Message-ID: <20180406221120.raync2b7mz7ja2kh@kekkonen.localdomain>
References: <382b6f23-d36e-696a-a536-bb5c05b10d34@univ-grenoble-alpes.fr>
 <1599416013.1022922.1513002815596.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <1513004631.22920.20.camel@suse.com>
 <1847654838.1115072.1513006781751.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <871008484.8702062.1520771930968.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <CAHp75Vf0EWNzn+aRrg8XRZpKvmNMq=OXmLiW5FVGx+20xTvDuw@mail.gmail.com>
 <20180315114146.4qlfnxp3hc27oy4z@paasikivi.fi.intel.com>
 <1869431231.416242.1522309861761.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <2042997128.420417.1522310025112.JavaMail.zimbra@univ-grenoble-alpes.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2042997128.420417.1522310025112.JavaMail.zimbra@univ-grenoble-alpes.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frédéric,

On Thu, Mar 29, 2018 at 09:53:45AM +0200, FRÉDÉRIC PARRENIN wrote:
> The second part now. 

I looked at the tables and it seems the dsdt lists two sensors (imx135 and
ov2740) but the rest of the information on how they're connected etc. is
missing. There are no sensor drivers in upstream kernel either.

So there would be some work to do before you could capture raw bayer images
from these devices.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
