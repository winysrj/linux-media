Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53577 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab1CCRie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 12:38:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?iso-8859-15?q?Lo=EFc_Akue?= <akue.loic@gmail.com>
Subject: Re: Demande de support V4L2
Date: Thu, 3 Mar 2011 18:38:45 +0100
Cc: linux-media@vger.kernel.org
References: <AANLkTinK1MvhNtAKpSwMARZhLNrW+FGLwd9KMcbdwOCa@mail.gmail.com> <AANLkTinLCj2BsBd9KuW7ziU2f8=wEyPkUDv3+vdNRgJ+@mail.gmail.com> <AANLkTimV2nP9kg=abuzM-Dnw7nWYe4vc39YEOGXS=K7z@mail.gmail.com>
In-Reply-To: <AANLkTimV2nP9kg=abuzM-Dnw7nWYe4vc39YEOGXS=K7z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103031838.45988.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Loïc,

As you've CC'ed the linux-media mailing list, I'll answer in English.

On Thursday 03 March 2011 18:25:29 Loïc Akue wrote:
> Bonjour Laurent,
> 
> J'ai un peu avancé dans ma tentative de mise en place de la capture vidéo.
> J'ai réussi à lever mon problème d'erreur de segmentation au démarrage, qui
> était due à une incompatibilité entre mon driver "saa7115.c" et celui de
> l'omap3isp.
> 
> Cette étape passée, j'ai entrepris d'utiliser 'media-ctl' pour configurer
> mes entités, et 'yavta' pour capturer de l'image.
> 
> Après avoir bloqué pendant quelque jours, je voulais savoir si l'entité
> CCDC acceptait que j'essaie de lui envoyer de la vidéo au format UYVY (
> V4L2_MBUS_FMT_UYVY8_1X16 ou V4L2_MBUS_FMT_Y8_1X8 ) ?
> 
> Désolé pour mes questions de débutant, mais je voudrais comprendre mes
> erreurs pour être sur d'aller dans la bonne direction.

The OMAP3 ISP CCDC module doesn't support V4L2_MBUS_FMT_UYVY8_1X16 yet. It 
should support V4L2_MBUS_FMT_Y8_1X8, but inteprets it as raw bayer data, so 
you will get strange results from the preview engine RGB to YUV conversion 
filter. You should be able to capture V4L2_MBUS_FMT_Y8_1X8 data at the CCDC 
output though. Feeding YUV data directly from the CCDC to the resizer, which 
is supported by the driver, isn't implemented yet.

-- 
Regards,

Laurent Pinchart
