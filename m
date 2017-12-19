Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40502 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750881AbdLSQEV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 11:04:21 -0500
Date: Tue, 19 Dec 2017 18:04:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Fabio Estevam <festevam@gmail.com>
Cc: Philippe Ombredanne <pombredanne@nexb.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Songjun Wu <songjun.wu@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v9 2/2] media: i2c: Add the ov7740 image sensor driver
Message-ID: <20171219160417.jagp3zni5cpyiyay@valkosipuli.retiisi.org.uk>
References: <20171211013146.2497-1-wenyou.yang@microchip.com>
 <20171211013146.2497-3-wenyou.yang@microchip.com>
 <20171219092246.3usg5mdyi27ivqlq@valkosipuli.retiisi.org.uk>
 <CAOMZO5BHSJv01SwZ2YNtGZTjMtOuOktET43qriK2fQ+jhE2TDA@mail.gmail.com>
 <20171219130537.2viv4wjcp4i3mdkj@valkosipuli.retiisi.org.uk>
 <CAOMZO5C5NJMffBEv2cdqKqUnTMQEYkqzN1JnJMS21PWtKuabnA@mail.gmail.com>
 <20171219134308.4plzpknvksbzhio7@valkosipuli.retiisi.org.uk>
 <CAOMZO5DYWA8O5N=CRm2uR3_7qZ4U1M8u8F-oBU8bJfnKXD4DSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5DYWA8O5N=CRm2uR3_7qZ4U1M8u8F-oBU8bJfnKXD4DSA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 19, 2017 at 12:31:46PM -0200, Fabio Estevam wrote:
> On Tue, Dec 19, 2017 at 11:43 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> 
> > Both seem to exist. See e.g. c3a3d1d6b8b363a02234e5564692db3647f183e6 .
> 
> This patch fixes .h files to use /* SPDX style comment, which is the
> recommendation.
> 
> .c files should use // SPDX style.

Agreed. I reverted the changes.

Thanks.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
