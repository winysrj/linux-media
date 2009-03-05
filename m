Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:41693 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZCEUnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 15:43:24 -0500
Received: by ey-out-2122.google.com with SMTP id 25so20416eya.37
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 12:43:20 -0800 (PST)
From: Eduard Huguet <eduardhc@gmail.com>
To: utar <utar101@gmail.com>
Subject: Re: Hauppauge NOVA-T 500 falls over after warm reboot
Date: Thu, 5 Mar 2009 21:43:17 +0100
Cc: linux-media@vger.kernel.org
References: <49AD88BF.30507@gmail.com> <617be8890903040026t679991bmf69b0076ff5bb64e@mail.gmail.com> <loom.20090305T195350-142@post.gmane.org>
In-Reply-To: <loom.20090305T195350-142@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903052143.18265.eduardhc@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A Dijous, 5 de març de 2009 20:57:38, utar va escriure:
> > Have you tried rmmoding the module (dvb_usb_dib0700) and reloading it?
> > I think that it was in such a case where it then wrongly detected the
> > card as 'cold', attempting to reload it, which failed.
>
> No as if I do a cold boot there isn't an issue.  I just thought I would
> report this so that the developers were aware.
>
> Many thanks for the suggestion though.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi, 
   I agree, the cold reboot does nothave this problem. Anyway, in a case a 
cold reboot is not possible (I sometimes reboot my backend remotely), stopping 
the backend and unloading the driver before rebooting seems to also work fine.

This might be a clue also about what's happening, anyway.

Best regards

