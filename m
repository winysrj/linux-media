Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38019 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab3JQM4L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 08:56:11 -0400
Message-ID: <525FDE54.2070909@ti.com>
Date: Thu, 17 Oct 2013 15:55:48 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: <linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	Jesse Barnes <jesse.barnes@intel.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	<linux-media@vger.kernel.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Zhang <markz@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Sunil Joshi <joshi@samsung.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Marcus Lorentzon <marcus.lorentzon@huawei.com>
Subject: Re: [PATCH/RFC v3 00/19] Common Display Framework
References: <1376068510-30363-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <52498146.4050600@ti.com> <524C1058.2050500@samsung.com> <524C1E78.6030508@ti.com> <52556370.1050102@samsung.com> <52579CB2.8050601@ti.com> <5257DEB5.6000708@samsung.com> <5257EF6A.4020005@ti.com> <5258084A.9000509@samsung.com> <52580EFF.2020401@ti.com> <525F9660.3010408@samsung.com> <525F9D4D.4000702@ti.com> <525FD760.20506@samsung.com>
In-Reply-To: <525FD760.20506@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="kKU0RKIxiEwP4p7WOJNHS6r7lofOUJaMn"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--kKU0RKIxiEwP4p7WOJNHS6r7lofOUJaMn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17/10/13 15:26, Andrzej Hajda wrote:

> I am not sure what exactly the encoder performs, if this is only image
> transport from dispc to panel CDF pipeline in both cases should look li=
ke:
> dispc ----> panel
> The only difference is that panels will be connected via different Linu=
x bus
> adapters, but it will be irrelevant to CDF itself. In this case I would=
 say
> this is DSI-master rather than encoder, or at least that the only
> function of the
> encoder is DSI.

Yes, as I said, it's up to the driver writer how he wants to use CDF. If
he doesn't see the point of representing the SoC's DSI encoder as a
separate CDF entity, nobody forces him to do that.

On OMAP, we have single DISPC with multiple parallel outputs, and a
bunch of encoder IPs (MIPI DPI, DSI, DBI, etc). Each encoder IP can be
connected to some of the DISPC's output. In this case, even if the DSI
encoder does nothing special, I see it much better to represent the DSI
encoder as a CDF entity so that the links between DISPC, DSI, and the
DSI peripherals are all there.

> If display_timings on input and output differs, I suppose it should be
> modeled
> as display_entity, as this is an additional functionality(not covered b=
y
> DSI standard AFAIK).

Well, DSI standard is about the DSI output. Not about the encoder's
input, or the internal operation of the encoder.

>>> Of course there are some settings which are not panel dependent and t=
hose
>>> should reside in DSI node.
>> Exactly. And when the two panels require different non-panel-dependent=

>> settings, how do you represent them in the DT data?
>=20
> non-panel-dependent setting cannot depend on panel, by definition :)

With "non-panel-dependent" setting I meant something that is a property
of the DSI master device, but still needs to be configured differently
for each panel.

Say, pin configuration. When using panel A, the first pin of the DSI
block could be clock+. With panel B, the first pin could be clock-. This
configuration is about DSI master, but it is different for each panel.

If we have separate endpoint in the DSI master for each panel, this data
can be there. If we don't have the endpoint, as is the case with
separate control bus, where is that data?

>>> Could you describe such scenario?
>> If we have two independent APIs, ctrl and video, that affect the same
>> underlying hardware, the DSI bus, we could have a scenario like this:
>>
>> thread 1:
>>
>> ctrl->op_foo();
>> ctrl->op_bar();
>>
>> thread 2:
>>
>> video->op_baz();
>>
>> Even if all those ops do locking properly internally, the fact that
>> op_baz() can be called in between op_foo() and op_bar() may cause prob=
lems.
>>
>> To avoid that issue with two APIs we'd need something like:
>>
>> thread 1:
>>
>> ctrl->lock();
>> ctrl->op_foo();
>> ctrl->op_bar();
>> ctrl->unlock();
>>
>> thread 2:
>>
>> video->lock();
>> video->op_baz();
>> video->unlock();
> I should mention I was asking for real hw/drivers configuration.
> I do not know what do you mean with video->op_baz() ?
> DSI-master is not modeled in CDF, and only CDF provides video
> operations.

It was just an example of the additional complexity with regarding
locking when using two APIs.

The point is that if the panel driver has two pointers (i.e. API), one
for the control bus, one for the video bus, and ops on both buses affect
the same hardware, the locking is not easy.

If, on the other hand, the panel driver only has one API to use, it's
simple to require the caller to handle any locking.

> I guess one scenario, when two panels are connected to single DSI-maste=
r.
> In such case both can call DSI ops, but I do not know how do you want t=
o
> prevent it in case of your CDF-T implementation.

No, that was not the case I was describing. This was about a single panel=
=2E

If we have two independent APIs, we need to define how locking is
managed for those APIs. Even if in practice both APIs are used by the
same driver, and the driver can manage the locking, that's not really a
valid requirement. It'd be almost the same as requiring that gpio API
cannot be called at the same time as i2c API.

 Tomi



--kKU0RKIxiEwP4p7WOJNHS6r7lofOUJaMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSX95UAAoJEPo9qoy8lh71h4MP/0TgZbRDoKvDQMdj9DQWGEuK
M/cmg2CXG7ytsol0tLyztO/b1Owx9p3rhuoao+9tJbFKjd35BQjTj4o8s25P8mMN
m+CXGdJ+SeFDcpi1jpFxqsJ77ck3ijoTcRWdFhWFLySIlKXM+ZRLJTxZhKYmNJhI
Ol6rBV29zk4rw6iHC6aQNvyZpiyKXU0siIaYywCaePzS1sgVlKXBuYksO0g+yYtB
fItIIGjMThOR0VSVWhi2i3FL9o7uI/0oKt4QuBOHspPJ5DUBz44uz/ExR6tkbD+p
eKQcLArDgchj+Mjce8eW1Yn3KjetN6aEpF/oAK/gX+ZCcl1E45QkiPaNwFMT7iJR
qzoCLiJ0MA34WqgTlErRfv+Kx9bn9XMypzNal6WTdUOv1+w7sACfZ7cPfDzf0H/K
EmPm0mz/6LBvcYDYYIqz+zdGAWzBWFsBdv5lRKCxHWw4kdGVFhTwAwzXPQGNkNId
/2M5DjhscerHzEdCEB4vE2Zo9D+Y9SyG+UW/Z46/AcpQMs4rPdUNfCo3DiBvV8na
j9nqLPmMsL9b3Zd2EBuLtzXjBZgnZ9zwxR/GrvVQVLBsWDMjTFXU3MsckP4f9/qr
ZQlRuPRCjHX6zg90anxnHQeHjt3t3DcPZrva4+6ipuQPab4e6MZptvlzT+yskf9m
q9Rsbizu5wky9JbpB+ep
=uZJF
-----END PGP SIGNATURE-----

--kKU0RKIxiEwP4p7WOJNHS6r7lofOUJaMn--
