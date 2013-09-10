Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43352 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752468Ab3IJWfN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Sep 2013 18:35:13 -0400
Date: Wed, 11 Sep 2013 01:35:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: RFC> multi-crop (was: Multiple Rectangle cropping)
Message-ID: <20130910223507.GF2057@valkosipuli.retiisi.org.uk>
References: <CAPybu_0J63XVEv=EPHbarn8EH9H5okEBbihaiZSOdwggkvV5xQ@mail.gmail.com>
 <5228FB2E.5050503@gmail.com>
 <CAPybu_2_kyqcmV0zh42X0LG+QvTDmFMJ_ywUsoe5WGh2k71S3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_2_kyqcmV0zh42X0LG+QvTDmFMJ_ywUsoe5WGh2k71S3Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Fri, Sep 06, 2013 at 10:30:18AM +0200, Ricardo Ribalda Delgado wrote:
> Any comment on this? Of course the names should be better chosen, this
> is just a declaration of intentions.

I forgot to ask one question: what's the behaviour of cropping on different
regions? Are the regions located on particular line or what?

Contrary to the case with AF rectaangles, I see fewer possibilities for
standardising the behaviour of multiple crop rectanges which decreases the
value of a generic interface: even if the interface is generic but you have
no idea what it'd actually do you wouldn't gain much.

For this reason it might also make sense to use a private IOCTL (and not a
control) to support the functionality. Or private selections (which we don't
have yet).

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
