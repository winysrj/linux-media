Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:44407 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbeFTMUb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 08:20:31 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?=
        <ville.syrjala@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] drm: Add generic colorkey properties
Date: Wed, 20 Jun 2018 15:20:26 +0300
Message-ID: <16624973.kIn7evqk0T@dimapc>
In-Reply-To: <20180619174011.GJ17671@n2100.armlinux.org.uk>
References: <20180526155623.12610-1-digetx@gmail.com> <20180529071103.GL23723@intel.com> <20180619174011.GJ17671@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, 19 June 2018 20:40:12 MSK Russell King - ARM Linux wrote:
> On Tue, May 29, 2018 at 10:11:03AM +0300, Ville Syrj=E4l=E4 wrote:
> > On Tue, May 29, 2018 at 02:48:22AM +0300, Dmitry Osipenko wrote:
> > > Though maybe "color components replacement" and "replacement with a
> > > complete transparency" could be factored out into a specific color
> > > keying modes.>=20
> > Yes. I've never seen those in any hardware. In fact I'm wondering where
> > is the userspace for all these complex modes? Ie. should we even bother
> > with them at this time?
>=20
> Such hardware does exist - here's what Armada 510 supports (and is
> supported via armada-drm):

It shouldn't be a problem to extend the list of common color keying modes w=
ith=20
a mode that is supported only by a particular HW. The only requirement for=
=20
adding a new mode is that this mode must be utilized by opensource userspac=
e=20
software.
