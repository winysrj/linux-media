Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52677 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbZKWSbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 13:31:34 -0500
Received: by fxm5 with SMTP id 5so4963043fxm.28
        for <linux-media@vger.kernel.org>; Mon, 23 Nov 2009 10:31:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6B0271AF-79D7-4AB1-B6F7-AB5A553EE1B2@wilsonet.com>
References: <a728f9f90911210918p4b1a4e2ajb3a8032d99f0cb5b@mail.gmail.com>
	 <6B0271AF-79D7-4AB1-B6F7-AB5A553EE1B2@wilsonet.com>
Date: Mon, 23 Nov 2009 13:31:39 -0500
Message-ID: <a728f9f90911231031n3ad56c7fwe7581296d64a593e@mail.gmail.com>
Subject: Re: ENE CIR driver
From: Alex Deucher <alexdeucher@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 21, 2009 at 1:30 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> On Nov 21, 2009, at 12:18 PM, Alex Deucher wrote:
>
>> Does anyone know if there is a driver or documentation available for
>> the ENE CIR controller that's incorporated into many of their keyboard
>> controllers?  If there is no driver but documentation, are there
>> drivers for other CIR controllers that could be used as a reference?
>
> Maxim Levitsky authored lirc_ene0100, which is in the lirc tarball and my lirc git tree now, with the intention of submitting it for upstream kernel inclusion once (if?) we get the base lirc bits accepted.
>

Excellent.  thanks for the heads up.

Alex
