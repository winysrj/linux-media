Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43660 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756942AbZJ1AbW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 20:31:22 -0400
Message-ID: <1149.212.50.134.58.1256689885.squirrel@webmail.kapsi.fi>
In-Reply-To: <829197380910261118x68fe0160jf76fd37c410276d8@mail.gmail.com>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
    <4AE497B5.8050801@iki.fi>
    <829197380910260836o4b17a65ex8c46d1db8d6d3027@mail.gmail.com>
    <4AE5C7F9.6000502@iki.fi>
    <829197380910260909m42ed776bt56754b882d7ac426@mail.gmail.com>
    <4AE5E481.8010805@iki.fi>
    <829197380910261118x68fe0160jf76fd37c410276d8@mail.gmail.com>
Date: Wed, 28 Oct 2009 02:31:25 +0200 (EET)
Subject: Re: em28xx DVB modeswitching change: call for testers
From: "Antti Palosaari" <crope@iki.fi>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ma 26.10.2009 20:18 Devin Heitmueller kirjoitti:
> On Mon, Oct 26, 2009 at 2:03 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 10/26/2009 06:09 PM, Devin Heitmueller wrote:
>>>
>>> On Mon, Oct 26, 2009 at 12:02 PM, Antti Palosaari<crope@iki.fi>  wrote:
>>>>
>>>> Is there any way to speed up Empia to handle streams bigger than ~45
>>>> Mbit/sec?
>>>
>>> Can you add a debug line that dumps out the values of register 0x01
>>> and register 0x5d and then send me the values?
>>
>> Here you are.
>
> Ok, let me digest the logs you sent and see what I can find out.

I did some more Windows tests here. It does not work (em2870 Reddo DVB-C)
even when Windows is used. My other Empia (em2875 Reddo DVB-T/C) based
DVB-C works.
em2870 & tda0023 broken
em2875 & drx-k works

What do you think, is it driver problem or is em2870 too slow to stream
such big stream? Does it help if we configure it to use bulk instead of
isoc?

Antti

