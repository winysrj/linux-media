Return-path: <linux-media-owner@vger.kernel.org>
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:54960
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0CCTL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 14:11:26 -0500
Received: from [10.3.4.27] (helo=vandecaa-laptop.localnet)
	by viper.mind.be with esmtp (Exim 4.69)
	(envelope-from <arnout@mind.be>)
	id 1NmtyQ-0005Ur-Kg
	for linux-media@vger.kernel.org; Wed, 03 Mar 2010 20:11:25 +0100
From: Arnout Vandecappelle <arnout@mind.be>
To: linux-media@vger.kernel.org
Subject: [PATCH RFCv1] Support for zerocopy to DSP on OMAP3
Date: Wed, 3 Mar 2010 20:11:06 +0100
References: <201003031512.45428.arnout@mind.be>
In-Reply-To: <201003031512.45428.arnout@mind.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003032011.07559.arnout@mind.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Here's a first attempt at allowing IO memory for USERPTR buffers.

 It also fixes another issue: it was assumed that 
dma->sglen == dma->nr_pages.  I'll split that up in a separate patch in the 
final version.

 Regards,
 Arnout

On Wednesday 03 March 2010 15:12:44, Arnout Vandecappelle wrote:
>  Hoi,
> 
>  [Please CC me, I'm not subscribed.]
> 
>  I'm implementing zerocopy transfer from a v4l2 camera to the DSP on an
> OMAP3 (based on earlier work by Stefan Kost [1][2]).  Therefore I'm using
> V4L2_MEMORY_USERPTR to pass in the memory area allocated by TI's DMAI
> driver.  However, this has flags VM_IO | VM_PFNMAP.  This means that it
> is not possible to do get_user_pages() on it - it's an area that is not
> pageable and possibly even doesn't pass the MMU.
> 
>  In order to support this kind of zerocopy construct, I propose to add
> checks for VM_IO | VM_PFNMAP and only get pages from areas that don't
> have these flags set.
> 
>  If I get positive feedback on this, I'll supply a patch.
> 
> 
> [1] https://bugzilla.gnome.org/show_bug.cgi?id=583890
> [2] http://thread.gmane.org/gmane.linux.drivers.video-input-
> infrastructure/6209

-- 
Arnout Vandecappelle                               arnout at mind be
Senior Embedded Software Architect                 +32-16-286540
Essensium/Mind                                     http://www.mind.be
G.Geenslaan 9, 3001 Leuven, Belgium                BE 872 984 063 RPR Leuven
LinkedIn profile: http://www.linkedin.com/in/arnoutvandecappelle
GPG fingerprint:  31BB CF53 8660 6F88 345D  54CC A836 5879 20D7 CF43
