Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:48658 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaJORD4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Oct 2014 13:03:56 -0400
Date: Wed, 15 Oct 2014 18:03:53 +0100 (BST)
From: William Towle <william.towle@codethink.co.uk>
To: g.liakhovetski@gmx.de
cc: ian.molton@codethink.co.uk,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com, sylvester.nawrocki@gmail.com,
	vladimir.barinov@cogentembedded.com
Subject: Re: RFC: soc_camera, rcar_vin, and adv7604
In-Reply-To: <20140710111218.60572c1fc814de541b886147@codethink.co.uk>
Message-ID: <alpine.DEB.2.02.1410151757420.5023@xk120>
References: <20140709174225.63a742ce09418cff539bb70a@codethink.co.uk> <Pine.LNX.4.64.1407091955080.25501@axis700.grange> <20140710111218.60572c1fc814de541b886147@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


   Earlier this year, a colleague and I sought advice on the
combination of "soc_camera + rcar_vin for capture, and the mainline
adv7604 driver (which we have modified to successfully drive the
adv7612).", with reasonable results, noting that we might move
towards "a soc_camera2 with pads support?".

   For the next stage of work, we have created a test branch that
contains an alternative version of rcar_vin.c, based on
v4l2-pci-skeleton.c [from the Documentation tree] and with device
tree initialisation code transplanted back into it.

   This presently creates device nodes happily, and if code from
soc_camera.c is transplanted, we observe appropriate low-level
interaction with hardware prompted by code in adv7604.c.

   I have not yet progressed to seeing calls to rcar_vin_irq()
succeed, however, and wondered if you could shed light onto the places
I might have overlooked?

Cheers,
   Wills.
   (William Towle; william.towle@codethink.co.uk)
