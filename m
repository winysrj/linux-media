Return-path: <linux-media-owner@vger.kernel.org>
Received: from zm-mta-out-2.u-ga.fr ([152.77.200.57]:52083 "EHLO
        zm-mta-out-2.u-ga.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753607AbeDAQRg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2018 12:17:36 -0400
Subject: Re: Webcams not recognized on a Dell Latitude 5285 laptop
To: linux-usb <linux-usb@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <382b6f23-d36e-696a-a536-bb5c05b10d34@univ-grenoble-alpes.fr>
 <1512989520.22920.2.camel@suse.com>
 <1607480650.971508.1513000904833.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <1513002580.22920.15.camel@suse.com>
 <1599416013.1022922.1513002815596.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <1513004631.22920.20.camel@suse.com>
 <1847654838.1115072.1513006781751.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <871008484.8702062.1520771930968.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <CAHp75Vf0EWNzn+aRrg8XRZpKvmNMq=OXmLiW5FVGx+20xTvDuw@mail.gmail.com>
 <20180315114146.4qlfnxp3hc27oy4z@paasikivi.fi.intel.com>
From: =?UTF-8?Q?Fr=c3=a9d=c3=a9ric_Parrenin?=
        <frederic.parrenin@univ-grenoble-alpes.fr>
Message-ID: <f69b1c0c-fce3-c1c5-4eeb-7941028991de@univ-grenoble-alpes.fr>
Date: Sun, 1 Apr 2018 18:17:02 +0200
MIME-Version: 1.0
In-Reply-To: <20180315114146.4qlfnxp3hc27oy4z@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Sakari et al.,

The acpi tables are apparently too big for the mailing lists.
So I put the file here:
https://mycore.core-cloud.net/index.php/s/DwTOb8TJJZYJtNe

Any information on what is going on with the webcams will be appreciated.

Thanks,

Frédéric

> 
> Or drivers. And a bit more than that actually. Assuming this is IPU3, that
> is. If that's the case, the short answer is there's no trivial way to
> support webcam-like functionality using this device. The ACPI tables would
> tell more details.
> 
> Could you send me the ACPI tables, i.e. the file produced by the command:
> 
> 	acpidump -o acpidump.bin
> 
> In Debian acpidump is included in acpica-tools package.
> 
> Thank you.
> 
