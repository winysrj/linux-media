Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38257 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161195AbcFML2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 07:28:10 -0400
Subject: Re: [PATCH 1/3] dt-bindings: Update Renesas R-Car FCP DT binding
To: Rob Herring <robh@kernel.org>
References: <1465479695-18644-1-git-send-email-kieran@bingham.xyz>
 <1465479695-18644-2-git-send-email-kieran@bingham.xyz>
 <20160610173724.GA19923@rob-hp-laptop>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"open list:MEDIA DRIVERS FOR RENESAS - FCP"
	<linux-media@vger.kernel.org>,
	"open list:MEDIA DRIVERS FOR RENESAS - FCP"
	<linux-renesas-soc@vger.kernel.org>,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
	<devicetree@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <575E98C6.8030904@bingham.xyz>
Date: Mon, 13 Jun 2016 12:28:06 +0100
MIME-Version: 1.0
In-Reply-To: <20160610173724.GA19923@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/06/16 18:37, Rob Herring wrote:
> On Thu, Jun 09, 2016 at 02:41:32PM +0100, Kieran Bingham wrote:
>> The FCP driver, can also support the FCPF variant for FDP1 compatible
> 
> Drop the comma.

Ok

>> processing.
>>
>> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
>> ---
>>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> With that,
> 
> Acked-by: Rob Herring <robh@kernel.org>

Thanks

