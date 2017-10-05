Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2992 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751208AbdJEHKM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 03:10:12 -0400
Date: Thu, 5 Oct 2017 10:09:37 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Leon Luo <leonl@leopardimaging.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH v8 2/2] media:imx274 V4l2 driver for Sony imx274 CMOS
 sensor
Message-ID: <20171005070937.hxt6hwgmdwgy2vmh@paasikivi.fi.intel.com>
References: <20171005000621.27841-1-leonl@leopardimaging.com>
 <20171005000621.27841-2-leonl@leopardimaging.com>
 <20171005062901.ofexwxfnun45linq@valkosipuli.retiisi.org.uk>
 <CADu3m9y+GUaD3LXBO-TBpQj2VYR2Js_c85J9+B=ZZnpW7Jr9fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADu3m9y+GUaD3LXBO-TBpQj2VYR2Js_c85J9+B=ZZnpW7Jr9fQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Leon,

On Thu, Oct 05, 2017 at 12:06:16AM -0700, Leon Luo wrote:
>    Hi Sakari,
>    I just got an email saying the patch is accepted. Do I still need to do
>    anything here? Do I need to add  MEDIA_CAMERA_SUPPORT dependency to
>    Kconfig and submit a new version? 

Please don't send HTML e-mail.

I've added the Kconfig dependency so there's no need to send further
versions of the patch.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
