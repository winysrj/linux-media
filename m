Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50062 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756900Ab3CFKyS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 05:54:18 -0500
Received: from mailout-de.gmx.net ([10.1.76.2]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LfUkZ-1UbFL42kbR-00p4Wf for
 <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 11:54:15 +0100
Date: Wed, 6 Mar 2013 11:54:14 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: jandegr1@dommel.be
Cc: linux-media@vger.kernel.org
Subject: Re: HAUPPAUGE HVR-930C analog tv feasible ??
Message-ID: <20130306105414.GA30253@minime.bse>
References: <20130225120117.atcsi16l8jokos80@webmail.dommel.be>
 <20130225083345.2d83d554@redhat.com>
 <20130301212854.93kflfbg4jc0kksk@webmail.dommel.be>
 <20130303000134.GA21166@minime.bse>
 <20130305223233.m32q5iyo2zwo4g0o@webmail.dommel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305223233.m32q5iyo2zwo4g0o@webmail.dommel.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 05, 2013 at 10:32:33PM +0100, jandegr1@dommel.be wrote:
> Your local avf4910a copy probably offers not much more than the one
> over here ?
> https://github.com/wurststulle/ngene_2400i/tree/2377b1fd99d91ff355a5e46881ef27ccc87cb376

No, mainly cleanup and coding style conversion.
A few DSP writes are amended to MSP_InitTable to set registers
a second time with different values.

  Daniel
