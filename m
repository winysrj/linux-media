Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38300 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbeK1IrY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 03:47:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Kieran Bingham <kieran@ksquared.org.uk>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v5 0/9] Asynchronous UVC
Date: Tue, 27 Nov 2018 23:48:27 +0200
Message-ID: <13783539.T3uYfGouAE@avalon>
In-Reply-To: <20181127201730.GC20692@amd>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com> <20181127201730.GC20692@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tuesday, 27 November 2018 22:17:30 EET Pavel Machek wrote:
> On Tue 2018-11-06 21:27:11, Kieran Bingham wrote:
> > From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> >=20
> > The Linux UVC driver has long provided adequate performance capabilities
> > for web-cams and low data rate video devices in Linux while resolutions
> > were low.
> >=20
> > Modern USB cameras are now capable of high data rates thanks to USB3 wi=
th
> > 1080p, and even 4k capture resolutions supported.
> >=20
> > Cameras such as the Stereolabs ZED (bulk transfers) or the Logitech BRIO
> > (isochronous transfers) can generate more data than an embedded ARM core
> > is able to process on a single core, resulting in frame loss.
> >=20
> > A large part of this performance impact is from the requirement to
> > =E2=80=98memcpy=E2=80=99 frames out from URB packets to destination fra=
mes. This
> > unfortunate requirement is due to the UVC protocol allowing a variable
> > length header, and thus it is not possible to provide the target frame
> > buffers directly.
> >=20
> > Extra throughput is possible by moving the actual memcpy actions to a w=
ork
> > queue, and moving the memcpy out of interrupt context thus allowing work
> > tasks to be scheduled across multiple cores.
>=20
> Hmm. Doing memcpy() on many cores is improvement but... not really.
> Would it be possible to improve kernel<->user interface, so it says
> "data is in this buffer, and it starts here" and so that memcpy in
> kernel is not neccessary?

Unfortunately not, as the UVC protocol segments the frame in a large number=
 of=20
small packets, each prefixed with a variable-length header. It's a poorly=20
designed protocol from that point of view.

=2D-=20
Regards,

Laurent Pinchart
