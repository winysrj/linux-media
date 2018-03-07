Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38590 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751182AbeCGL2E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 06:28:04 -0500
Date: Wed, 7 Mar 2018 13:28:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Fabio Estevam <festevam@gmail.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH] media: ov5640: fix get_/set_fmt colorspace related fields
Message-ID: <20180307112800.o3yhldl2xx75punp@valkosipuli.retiisi.org.uk>
References: <1520355879-20291-1-git-send-email-hugues.fruchet@st.com>
 <20180307081302.h47mjhlkeq72shw7@valkosipuli.retiisi.org.uk>
 <CAOMZO5BEi_dWmerMx5i3UoWU_3G7m3kgUWyGu4LfNMdvWNF+pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5BEi_dWmerMx5i3UoWU_3G7m3kgUWyGu4LfNMdvWNF+pw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Wed, Mar 07, 2018 at 06:51:26AM -0300, Fabio Estevam wrote:
> Hi Sakari,
> 
> On Wed, Mar 7, 2018 at 5:13 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> 
> >> @@ -2497,16 +2504,22 @@ static int ov5640_probe(struct i2c_client *client,
> >>       struct fwnode_handle *endpoint;
> >>       struct ov5640_dev *sensor;
> >>       int ret;
> >> +     struct v4l2_mbus_framefmt *fmt;
> >
> > This one I'd arrange before ret. The local variable declarations should
> > generally look like a Christmas tree but upside down.
> 
> It seems Mauro is not happy with reverse Christmas tree ordering:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg127221.html

There are other arguments supporting the change such as:

- alignment with the rest of the driver and
- putting similar definitions together (return value vs. pointers somewhere
  else).

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
