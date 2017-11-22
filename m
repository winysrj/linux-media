Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:25081 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752493AbdKVMVJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 07:21:09 -0500
Message-ID: <1511353247.3539.10.camel@linux.intel.com>
Subject: Re: [PATCH 23/30] [media] atomisp: deprecate pci_get_bus_and_slot()
From: Alan Cox <alan@linux.intel.com>
To: Sinan Kaya <okaya@codeaurora.org>, linux-pci@vger.kernel.org,
        timur@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Valentin Vidic <Valentin.Vidic@CARNet.hr>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)"
        <linux-media@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 22 Nov 2017 12:20:47 +0000
In-Reply-To: <1511328675-21981-24-git-send-email-okaya@codeaurora.org>
References: <1511328675-21981-1-git-send-email-okaya@codeaurora.org>
         <1511328675-21981-24-git-send-email-okaya@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-11-22 at 00:31 -0500, Sinan Kaya wrote:
> pci_get_bus_and_slot() is restrictive such that it assumes domain=0
> as
> where a PCI device is present. This restricts the device drivers to
> be
> reused for other domain numbers.

The ISP v2 will always been in domain 0.

Alan
