Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:60867 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbeJBUkf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Oct 2018 16:40:35 -0400
Date: Tue, 2 Oct 2018 15:57:01 +0200
From: Philippe De Muyter <phdm@macq.eu>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/2] [media] imx214: device tree binding
Message-ID: <20181002135701.GA6910@frolo.macqel>
References: <20181002134648.14225-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002134648.14225-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 02, 2018 at 03:46:48PM +0200, Ricardo Ribalda Delgado wrote:
> Document bindings for imx214 camera sensor
 ...
> +Optional Properties:
> +- flash-leds: See ../video-interfaces.txt
> +- lens-focus: See ../video-interfaces.txt
> +
> +The imx274 device node should contain one 'port' child node with

imx214 
