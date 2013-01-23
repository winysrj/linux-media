Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:57913 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab3AWNAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 08:00:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC v3 01/15] [media] Add common video interfaces OF bindings documentation
Date: Wed, 23 Jan 2013 13:59:39 +0100
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org
References: <1356969793-27268-2-git-send-email-s.nawrocki@samsung.com> <201301211131.11047.hverkuil@xs4all.nl> <50FFB9A4.1090300@samsung.com>
In-Reply-To: <50FFB9A4.1090300@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301231359.39655.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 23 January 2013 11:21:24 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 01/21/2013 11:31 AM, Hans Verkuil wrote:
> [...]
> >> +Required properties
> >> +-------------------
> >> +
> >> +If there is more than one 'port' or more than one 'endpoint' node following
> >> +properties are required in relevant parent node:
> >> +
> >> +- #address-cells : number of cells required to define port number, should be 1.
> >> +- #size-cells    : should be zero.
> >> +
> >> +Optional endpoint properties
> >> +----------------------------
> >> +
> >> +- remote-endpoint: phandle to an 'endpoint' subnode of the other device node.
> >> +- slave-mode: a boolean property, run the link in slave mode. Default is master
> >> +  mode.
> >> +- bus-width: number of data lines, valid for parallel busses.
> >> +- data-shift: on parallel data busses, if bus-width is used to specify the
> >> +  number of data lines, data-shift can be used to specify which data lines are
> >> +  used, e.g. "bus-width=<10>; data-shift=<2>;" means, that lines 9:2 are used.
> >> +- hsync-active: active state of HSYNC signal, 0/1 for LOW/HIGH respectively.
> >> +- vsync-active: active state of VSYNC signal, 0/1 for LOW/HIGH respectively.
> >> +  Note, that if HSYNC and VSYNC polarities are not specified, embedded
> >> +  synchronization may be required, where supported.
> >> +- data-active: similar to HSYNC and VSYNC, specifies data line polarity.
> >> +- field-even-active: field signal level during the even field data transmission.
> >> +- pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
> >> +  signal.
> >> +- data-lanes: an array of physical data lane indexes. Position of an entry
> >> +  determines logical lane number, while the value of an entry indicates physical
> >> +  lane, e.g. for 2-lane MIPI CSI-2 bus we could have "data-lanes = <1>, <2>;",
> >> +  assuming the clock lane is on hardware lane 0. This property is valid for
> >> +  serial busses only (e.g. MIPI CSI-2).
> >> +- clock-lanes: a number of physical lane used as a clock lane.
> > 
> > This doesn't parse. Do you mean:
> > 
> > "a number of physical lanes used as clock lanes."?
> 
> Not really, an index (an array of indexes?) of physical lanes(s) used as clock
> lane (s).
> 
> Currently there are only use cases for one clock lane (MIPI CSI-2 bus).
> I'm not sure what's better, to keep that in singular (clock-lane) or plural
> form. The plural form seems more generic. So I'm inclined to define it as:
> 
> clock-lanes - similarly to 'data-lanes' property, an array of physical
> clock lane indexes. For MIPI CSI-2 bus this array contains only one entry.
> 
> Would it be OK like this ?

I'd go with this:

- clock-lanes: an array of physical clock lane indexes. Position of an entry
  determines the logical lane number, while the value of an entry indicates
  physical lane, e.g. for a MIPI CSI-2 bus we could have "clock-lanes = <0>;",
  which places the clock lane on hardware lane 0. This property is valid for
  serial busses only (e.g. MIPI CSI-2). Note that for the MIPI CSI-2 bus this
  array contains only one entry.

Regards,

	Hans
