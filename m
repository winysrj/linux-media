Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:57804 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbZHKRmY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 13:42:24 -0400
Date: Tue, 11 Aug 2009 19:42:15 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Olaf Titz <Olaf.Titz@inka.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca: add g_std/s_std methods
Message-ID: <20090811194215.0dd6e3f8@tele>
In-Reply-To: <E1MaElV-0004zK-7v@bigred.inka.de>
References: <E1MaElV-0004zK-7v@bigred.inka.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 09 Aug 2009 22:13:12 +0200
Olaf Titz <Olaf.Titz@inka.de> wrote:

> Some applications are unhappy about getting EINVAL errors for
> query/set TV standard operations, especially (or only?) when working
> over the v4l1compat.so bridge. This patch adds the appropriate
> methods to the gspca driver (claim to support all TV modes, setting
> TV mode does nothing).

The vidioc_s_std() has been removed last month by Németh Márton
according to the v4l2 API http://v4l2spec.bytesex.org/spec/x448.htm

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
