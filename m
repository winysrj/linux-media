Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:35599 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdFZRrF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 13:47:05 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v1 2/6] [media] ov9650: add device tree support
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20170626163102.GQ12407@valkosipuli.retiisi.org.uk>
Date: Mon, 26 Jun 2017 19:46:34 +0200
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D780984B-70A1-4E9C-A887-DD2CBAAC7CCA@goldelico.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com> <1498143942-12682-3-git-send-email-hugues.fruchet@st.com> <20170626163102.GQ12407@valkosipuli.retiisi.org.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hugues Fruchet <hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> Am 26.06.2017 um 18:31 schrieb Sakari Ailus <sakari.ailus@iki.fi>:
>=20
> Hi Hugues,
>=20
> On Thu, Jun 22, 2017 at 05:05:38PM +0200, Hugues Fruchet wrote:
>> @@ -1545,15 +1577,22 @@ static int ov965x_remove(struct i2c_client =
*client)
>> }
>>=20
>> static const struct i2c_device_id ov965x_id[] =3D {
>> -	{ "OV9650", 0 },
>> -	{ "OV9652", 0 },
>> +	{ "OV9650", 0x9650 },
>> +	{ "OV9652", 0x9652 },
>=20
> This change does not appear to match with the patch description nor it =
the
> information is used. How about not changing it, unless there's a =
reason to?
> The same for the data field of the of_device_id array below.

I think it could/should be used to check if the camera chip that is =
found
by reading the product-id and version registers does match what the =
device
tree expects and abort probing on a mismatch.

BR,
Nikolaus
