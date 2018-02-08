Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0069.outbound.protection.outlook.com ([104.47.42.69]:36310
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751269AbeBHBD6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 20:03:58 -0500
From: Satish Kumar Nagireddy <SATISHNA@xilinx.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>
Subject: RE: [PATCH 0/8] Add support for multi-planar formats and 10 bit
 formats
Date: Thu, 8 Feb 2018 01:03:56 +0000
Message-ID: <CY4PR02MB25974D7795FA94C8E9E6359FACF30@CY4PR02MB2597.namprd02.prod.outlook.com>
References: <1518042578-22771-1-git-send-email-satishna@xilinx.com>
 <20180207223336.6uqmczeejwvzoqod@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180207223336.6uqmczeejwvzoqod@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review. I will provide the rst documentation.

Regards,
Satish

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Wednesday, February 07, 2018 2:34 PM
> To: Satish Kumar Nagireddy <SATISHNA@xilinx.com>
> Cc: linux-media@vger.kernel.org; laurent.pinchart@ideasonboard.com;
> michal.simek@xilinx.com; Hyun Kwon <hyunk@xilinx.com>; Satish Kumar
> Nagireddy <SATISHNA@xilinx.com>
> Subject: Re: [PATCH 0/8] Add support for multi-planar formats and 10 bit
> formats
>=20
> Hi Satish,
>=20
> On Wed, Feb 07, 2018 at 02:29:30PM -0800, Satish Kumar Nagireddy wrote:
> > Jeffrey Mouroux (1):
> >   uapi: media: New fourcc codes needed by Xilinx Video IP
> >
> > Rohit Athavale (1):
> >   media-bus: uapi: Add YCrCb 420 media bus format
>=20
> Could you add ReST documentation for these formats?
>=20
> --
> Regards,
>=20
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
