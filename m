Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:37707 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830AbZLRQkn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 11:40:43 -0500
Message-ID: <4B2B916E.9080406@onelan.com>
Date: Fri, 18 Dec 2009 14:27:58 +0000
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Paulo Assis <pj.assis@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Adaptec VideOh! DVD Media Center
References: <59cf47a80912180605o41708efao769d09d46b20a87e@mail.gmail.com>
In-Reply-To: <59cf47a80912180605o41708efao769d09d46b20a87e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Paulo Assis wrote:
> For the box to function it needs a firmware upload. Currently this is
> managed by a udev script that in turn calls an application (multiload)
> that provides for the upload.
> What I would like to know is, if this the best way to handle it?
> The problem with this process is that it will always require
> installing and configuring additional software (multiload and udev
> script), besides the firmware.
> Is there any simpler/standard way of handling these firmware uploads ?
> 
Look at Documentation/firmware_class/README. There's a mechanism called
request_firmware() that does what you want; it's used in several V4L
drivers if you need an example usage.
-- 
Simon Farnsworth

