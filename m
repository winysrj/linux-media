Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34586 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbbFJBko (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2015 21:40:44 -0400
Message-ID: <1433900441.11979.11.camel@gmail.com>
Subject: Re: [PATCH] USB: uvc: add support for the Microsoft Surface Pro 3
 Cameras
From: Dennis Chen <barracks510@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Date: Tue, 09 Jun 2015 18:40:41 -0700
In-Reply-To: <2450709.nghA4lNjjK@avalon>
References: <1433879614.3036.3.camel@gmail.com> <3765742.rat6LA2JPE@avalon>
	 <1433898546.11979.6.camel@gmail.com> <2450709.nghA4lNjjK@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Is this needed ? Looking at the patch your cameras are UVC-compliant 
> and 
> should thus be picked by the uvcvideo driver without any change to 
> the code.

The cameras are UVC-compliant but are not recognized by the uvc driver.
The patch forces the uvc driver to pick up the camera if present.

