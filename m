Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38166C10F09
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13AAB2133F
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfCHNSd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:18:33 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45683 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfCHNSd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 08:18:33 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id CA8F4E0010;
        Fri,  8 Mar 2019 13:18:29 +0000 (UTC)
Date:   Fri, 8 Mar 2019 14:19:03 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        niklas soderlund <niklas.soderlund@ragnatech.se>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 00/31] v4l: add support for multiplexed streams
Message-ID: <20190308131903.daja4zzfp47pucsf@uno.localdomain>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190307094725.5nrvzz7hn7gfmgxe@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wjmaah4pcyyauced"
Content-Disposition: inline
In-Reply-To: <20190307094725.5nrvzz7hn7gfmgxe@paasikivi.fi.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--wjmaah4pcyyauced
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari and Niklas,

On Thu, Mar 07, 2019 at 11:47:26AM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Tue, Mar 05, 2019 at 07:51:19PM +0100, Jacopo Mondi wrote:
> > Hello,
> >    third version of multiplexed stream support patch series.
> >
> > V2 sent by Niklas is available at:
> > https://patchwork.kernel.org/cover/10573817/
> >
> > As per v2, most of the core patches are work from Sakari and Laurent, with
> > Niklas' support on top for adv748x and rcar-csi2.
> >
> > The use case of the series remains the same: support for virtual channel
> > selection implemented on R-Car Gen3 and adv748x. Quoting the v2 cover letter:
> >
> > -------------------------------------------------------------------------------
> > I have added driver support for the devices used on the Renesas Gen3
> > platforms, a ADV7482 connected to the R-Car CSI-2 receiver. With these
> > changes I can control which of the analog inputs of the ADV7482 the
> > video source is captured from and on which CSI-2 virtual channel the
> > video is transmitted on to the R-Car CSI-2 receiver.
> >
> > The series adds two new subdev IOCTLs [GS]_ROUTING which allows
> > user-space to get and set routes inside a subdevice. I have added RFC
> > support for these to v4l-utils [2] which can be used to test this
> > series, example:
> >
> >     Check the internal routing of the adv748x csi-2 transmitter:
> >     v4l2-ctl -d /dev/v4l-subdev24 --get-routing
> >     0/0 -> 1/0 [ENABLED]
> >     0/0 -> 1/1 []
> >     0/0 -> 1/2 []
> >     0/0 -> 1/3 []
> >
> >
> >     Select that video should be outputed on VC 2 and check the result:
> >     $ v4l2-ctl -d /dev/v4l-subdev24 --set-routing '0/0 -> 1/2 [1]'
> >
> >     $ v4l2-ctl -d /dev/v4l-subdev24 --get-routing
> >     0/0 -> 1/0 []
> >     0/0 -> 1/1 []
> >     0/0 -> 1/2 [ENABLED]
> >     0/0 -> 1/3 []
> > -------------------------------------------------------------------------------
> >
> > Below is reported the media graph of the system used for testing [1].
> >
> > v4l2-ctl patches to handle the newly introduced IOCTLs are available from
> > Niklas' repository at:
> > git://git.ragnatech.se/v4l-utils routing
>
> Could you send the v4l2-ctl patches out as well, please?
>

Niklas sent them on late 2017... time flies :)
https://patchwork.kernel.org/patch/10113189/

Would you like to have them re-sent?

Thanks
   j

> --
> Sakari Ailus
> sakari.ailus@linux.intel.com

--wjmaah4pcyyauced
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyCa8cACgkQcjQGjxah
Vjy6GRAAgc+q3fHksK5T1s8louPUrZnyISKxkLqQ3Ose5BlsGyRcKuqEbMoB5Jjf
oXNWenevFt1Gb27vg2OevU6kfYuStHe6ZbH7tRwO2NC0h3t3E1oQvWbNzAmv0smj
VoU03t8ybuIbilukdG4hdQKBr1jmik9MetL7nIC/FV7MFjDD3uFJC7tmsoyCw15T
Zuv5IVF7LKrV3qBDK7Y/0igq3xyMVGz6WBhM4SGX+sGwNOVkPeln5igtda8zjx6M
BZWNGQvRBFuWbfX8M2spraw0zmesyVmwsFSNNQgNNpwGc2I87GNAl0unad9W2bCD
KVtd0Dz8+mKcwwnnlBl1styN/gGOzdKD4YNxSVyVR+2Oures8qAo/pbLObian5w8
VsiNWzoe7n2DvtsxztwBRzTZ7T8nukde95PVDSD89OnMhuUory3KXQTGrCJJb7m5
0DpblmCDQDX1K4LA+EY8/flSbEPM1pQJ0Fzp/ImkZdy5orgJj4DDbwDCc624bDp/
YKf5rAQm2mFI4WIQKLAN+DYAWRrgxxpKjWz1xDE3rEwUIITBAgJ/hMTCuLb7Qbjn
UXQqxvqR8ThDIVjGlr8EsjXc4VEfi8cRvm1e87hMTxgu+f3n3xYDYHi+aoPSbYaV
5XWeg+/thRdc15Q1aQRY4OLWUFdXpPAY8KafBC/SaWUpmb6mWJo=
=gOeD
-----END PGP SIGNATURE-----

--wjmaah4pcyyauced--
