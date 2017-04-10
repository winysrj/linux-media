Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:62145 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753224AbdDJKBf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 06:01:35 -0400
Subject: Re: [PATCH v2 5/8] v4l: Switch from V4L2 OF not V4L2 fwnode API
To: Mika Westerberg <mika.westerberg@intel.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <14918382.izlyCngq8n@avalon>
 <20170407105805.GG4192@valkosipuli.retiisi.org.uk>
 <1895617.xparv3opoe@avalon>
 <20170407225515.GM4192@valkosipuli.retiisi.org.uk>
 <20170410092147.GE2957@lahna.fi.intel.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <3e78d983-86da-3ac8-6c77-0720d8e0f534@linux.intel.com>
Date: Mon, 10 Apr 2017 12:59:36 +0300
MIME-Version: 1.0
In-Reply-To: <20170410092147.GE2957@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mika and Laurent,

On 04/10/17 12:21, Mika Westerberg wrote:
> On Sat, Apr 08, 2017 at 01:55:15AM +0300, Sakari Ailus wrote:
>>> My ACPI knowledge is limited, but don't ACPI nodes have 4 character names that 
>>> can be combined in a string to create a full path ?
>>
>> There is something, yes, but the ACPI framework currently has no such
>> functionality. I believe it could be implemented though. Cc Mika.
> 
> All ACPI node names are 32-bit integers and those are combined to form a
> path, like \_SB.PCI0.I2C0 and so on. A single ACPI node name cannot be
> larger than 4 chars, though.

On OF, each node has a full_node string attached to it. You could
produce a similar string on ACPI, it is not currently done. Adding such
a string to each fwnode would require some extra memory as well. I
wonder if that could be a Kconfig option.

It would help debugging though.

Providing this information to the user space has been proposed as well:
Devicetree spec defines the syntax for such strings. The user can use
that information for recognising a particular device in the system.

The ACPI spec does, too, but it is limited to ACPI nodes and does not
address hierarchical data extensions. We'd define the syntax for those
ourselves.

Mika: what do you think?

On omap3isp and other drivers --- I think the solution for now should be
to assume OF instead. These drivers will be used on OF platforms only
anyway.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
