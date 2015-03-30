Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46193 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbbC3Rlx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 13:41:53 -0400
Date: Mon, 30 Mar 2015 19:41:23 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 14/15] omap3isp: Add support for the Device Tree
Message-ID: <20150330174123.GA2658@earth>
References: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
 <1427324259-18438-15-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1427324259-18438-15-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

The code crashed for me on Nokia N900. I found the following
problem:

On Thu, Mar 26, 2015 at 12:57:38AM +0200, Sakari Ailus wrote:
> [...]
> +static int isp_of_parse_nodes(struct device *dev,
> +			      struct v4l2_async_notifier *notifier)
> +{
> +	struct device_node *node;

struct device_node *node = NULL;

to avoid feeding a random pointer into of_graph_get_next_endpoint():

> [...]
> +	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
> +	       (node = of_graph_get_next_endpoint(dev->of_node, node))) {
> [...]

-- Sebastian

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVGYrAAAoJENju1/PIO/qaJnkP/Aqrzb4SS4iyIjg8DD8NcYp6
kl8MbY5e9IXqMktydeIBDBijljDG+vhHrejEUQuVOI+/dTWC806Ulc9nEdv6V3nF
M03HoDBR3J2aWx/B1mx1HGBpshiRCQA+xkZgwiayxNpp81lSu1rUkiwdqYx+yNEv
EvbE+3oPlc+qSiGIiHQtnvqwUBQnrxnmssocZciZmGzG/jesXzzUweNPIfWt0d6e
iUAfbA+Xjkge410HXQ84f80h6TlAkwPqAZU2UwHVoTrGdrTfUQED9/V/ubexJDU1
woaaA0HnCla1Kg43MFDYfGXz1grnGyhOQwZ+7Uql3WeZ3JyxvnD354P17Q3md2mp
Vk2Noo45j3n2sHS4M44sVlUYd+iWp12rZNr4wS/YakAw2kzR5g+5MupFVrDq0WbB
6CSJaitRoCOrPxNZtQR9ReK/ZuhzHNLtk/8fHl6n1mol5SiVWHy3i3IoEg0cSB/x
4mntK3t4FFrQ7Ncz6pB5uygK6+gDdpX/rQlMPJhshrtRX+8sEoaVzrg3JyfXyTmI
u6rRT8/TytOZD04Z/IdmcBgNmR8euh18l21LcwK+FG58d7qzAtfWxqGQUazHHDwe
BoQLY6GxAm0yXjSkjTwkethLsCrjsdiOw6g2GFiZHZJHjUqDxzSTZTii7Ohn9Nte
kp5XwHWnmxQLW6pVew2e
=PbtZ
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
