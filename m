Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46504 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753120AbdDJJV4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 05:21:56 -0400
Date: Mon, 10 Apr 2017 12:21:47 +0300
From: Mika Westerberg <mika.westerberg@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 5/8] v4l: Switch from V4L2 OF not V4L2 fwnode API
Message-ID: <20170410092147.GE2957@lahna.fi.intel.com>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <14918382.izlyCngq8n@avalon>
 <20170407105805.GG4192@valkosipuli.retiisi.org.uk>
 <1895617.xparv3opoe@avalon>
 <20170407225515.GM4192@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170407225515.GM4192@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 08, 2017 at 01:55:15AM +0300, Sakari Ailus wrote:
> > My ACPI knowledge is limited, but don't ACPI nodes have 4 character names that 
> > can be combined in a string to create a full path ?
> 
> There is something, yes, but the ACPI framework currently has no such
> functionality. I believe it could be implemented though. Cc Mika.

All ACPI node names are 32-bit integers and those are combined to form a
path, like \_SB.PCI0.I2C0 and so on. A single ACPI node name cannot be
larger than 4 chars, though.
