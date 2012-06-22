Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53156 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab2FVSvC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 14:51:02 -0400
Received: by obbuo13 with SMTP id uo13so2307972obb.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 11:51:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE4BC43.9070100@gmail.com>
References: <4FE4BC43.9070100@gmail.com>
Date: Fri, 22 Jun 2012 15:51:02 -0300
Message-ID: <CALF0-+VM902A0x+TNXB1qe_jhKcYOs6ti1hMZBsTuTe6Ucmpeg@mail.gmail.com>
Subject: Re: Tuner NOGANET NG-PTV FM
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Ariel Mammoli <cmammoli@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ariel,

On Fri, Jun 22, 2012 at 3:41 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>
> I have a tuner NOGANET "NG-FM PTV" which has the Philips chip 7134.
> I have reviewed the list of values several times but can not find it.
> What are the correct values to configure the module saa7134?
>

That's a PCI card, right? PCI are identified by subvendor  and subdevice IDs.

Can you tell us those IDs for your card?

Regards,
Ezequiel.
