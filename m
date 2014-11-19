Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail03.solnet.ch ([212.101.4.137]:27751 "EHLO mail03.solnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464AbaKSX1m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:42 -0500
Message-ID: <546D25D7.9050703@openelec.tv>
Date: Thu, 20 Nov 2014 00:20:55 +0100
From: Stephan Raue <mailinglists@openelec.tv>
MIME-Version: 1.0
To: =?windows-1252?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: linux-input@vger.kernel.org, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: bisected: IR press/release behavior changed in 3.17, repeat events
References: <54679469.1010500@openelec.tv> <20141119195019.GA20784@hardeman.nu>
In-Reply-To: <20141119195019.GA20784@hardeman.nu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.11.2014 um 20:50 schrieb David Härdeman:
> On Sat, Nov 15, 2014 at 06:59:05PM +0100, Stephan Raue wrote:
>> Hi
>>
>> with kernel 3.17 using a RC6 remote with a buildin nuvoton IR receiver (not
>> tested others, but i think its a common problem) when pressing/releasing the
>> same button often within 1 second there will no release event sent. Instead
>> we get repeat events. To get the release event i must press the same button
>> with a delay of ~ 1sec.
>>
>> the evtest output for kernel with the difference 3.16 and 3.17 looks like
> Hi,
>
> could you try the working and non-working versions with debugging output
> enabled from the in-kernel rc6 decoder (i.e. set debug for the rc-core
> module) and post the two different outputs?
>
> //David
>

Hi David

with kernel 3.17: (you dont see the messages with "toggle 1" here)
if i press once and wait:

[   72.175548] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[   72.175555] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[   72.175559] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, protocol 0x0011, scancode 0x800f041f
[   72.350377] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[   72.350385] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[   72.598265] keyup key 0x006c
[   81.456175] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[   81.456182] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[   81.456186] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, protocol 0x0011, scancode 0x800f041f
[   81.631033] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[   81.631045] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[   81.878230] keyup key 0x006c
[   98.976060] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[   98.976067] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[   98.976071] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, protocol 0x0011, scancode 0x800f041f
[   99.150910] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[   99.150918] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[   99.398575] keyup key 0x006c

with kernel 3.17 if i press the same key often without a longer break:

[  298.971043] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  298.971051] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  298.971055] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, protocol 0x0011, scancode 0x800f041f
[  299.162854] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  299.162863] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  299.273112] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  299.273119] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  299.396907] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  299.396913] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  299.484521] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  299.484533] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  299.649523] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  299.649533] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  299.822100] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  299.822107] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  299.970903] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  299.970910] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  300.133381] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  300.133392] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  300.310163] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  300.310168] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  300.496736] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  300.496743] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  300.660526] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  300.660535] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  300.829385] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  300.829390] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  301.005423] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  301.005430] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  301.167183] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  301.167195] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  301.330419] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  301.330426] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  301.505621] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  301.505628] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  301.686007] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  301.686013] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  301.846361] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  301.846370] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  302.016169] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  302.016180] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  302.186990] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  302.186997] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  302.364885] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  302.364893] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  302.507666] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  302.507673] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  302.634184] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  302.634191] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  302.762198] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  302.762206] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  302.942671] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  302.942678] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  303.085449] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  303.085456] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  303.186777] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  303.186784] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  303.271129] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  303.271143] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  303.348733] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  303.348743] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  303.513377] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  303.513382] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  303.616009] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  303.616019] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  303.688259] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  303.688265] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  303.752897] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  303.752905] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  303.940450] RC6(6A) proto 0x0011, scancode 0x800f041f (toggle: 0)
[  303.940458] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  304.187848] keyup key 0x006c
[  311.405294] RC6 decode failed at state 0 (250us pulse)
[  311.405302] RC6 decode failed at state 0 (6350us space)
[  331.899445] RC6 decode failed at state 0 (250us pulse)
[  331.899454] RC6 decode failed at state 0 (6350us space)

with kernel 3.16: (you see messages with "RC6(6A) scancode 0x800f041f 
(toggle: 1)"

pressing the buttons with some delay between:

[  112.360318] RC6(6A) scancode 0x800f041f (toggle: 1)
[  112.360326] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  112.360330] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  112.484703] RC6(6A) scancode 0x800f041f (toggle: 1)
[  112.484711] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  112.733389] keyup key 0x006c
[  114.605782] RC6(6A) scancode 0x800f041f (toggle: 0)
[  114.605795] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  114.605802] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  114.730174] RC6(6A) scancode 0x800f041f (toggle: 0)
[  114.730182] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  114.979244] keyup key 0x006c
[  117.093793] RC6(6A) scancode 0x800f041f (toggle: 1)
[  117.093800] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  117.093805] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  117.218137] RC6(6A) scancode 0x800f041f (toggle: 1)
[  117.218144] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  117.465012] keyup key 0x006c
[  125.029704] RC6 decode failed at state 0 (300us pulse)
[  125.029714] RC6 decode failed at state 0 (95250us space)
[  125.795347] RC6(6A) scancode 0x800f041f (toggle: 0)
[  125.795354] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  125.795358] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  125.919612] RC6(6A) scancode 0x800f041f (toggle: 0)
[  125.919623] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  126.168501] keyup key 0x006c
[  128.740748] RC6 decode failed at state 0 (250us pulse)
[  128.740756] RC6 decode failed at state 0 (95250us space)


pressing fast:

[  192.644815] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  192.753373] RC6(6A) scancode 0x800f041f (toggle: 0)
[  192.753384] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  192.854618] RC6(6A) scancode 0x800f041f (toggle: 1)
[  192.854625] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  192.854627] keyup key 0x006c
[  192.854631] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  192.960172] RC6(6A) scancode 0x800f041f (toggle: 1)
[  192.960178] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  193.063672] RC6(6A) scancode 0x800f041f (toggle: 0)
[  193.063686] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  193.063690] keyup key 0x006c
[  193.063698] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  193.161351] RC6(6A) scancode 0x800f041f (toggle: 0)
[  193.161359] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  193.263223] RC6(6A) scancode 0x800f041f (toggle: 1)
[  193.263235] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  193.263238] keyup key 0x006c
[  193.263245] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  193.366792] RC6(6A) scancode 0x800f041f (toggle: 1)
[  193.366800] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  193.487952] RC6(6A) scancode 0x800f041f (toggle: 0)
[  193.487959] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  193.487962] keyup key 0x006c
[  193.487966] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  193.655452] RC6(6A) scancode 0x800f041f (toggle: 1)
[  193.655459] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  193.655462] keyup key 0x006c
[  193.655466] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  193.757056] RC6(6A) scancode 0x800f041f (toggle: 1)
[  193.757064] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  193.858806] RC6(6A) scancode 0x800f041f (toggle: 0)
[  193.858811] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  193.858813] keyup key 0x006c
[  193.858816] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  193.975154] RC6(6A) scancode 0x800f041f (toggle: 0)
[  193.975165] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  194.078759] RC6(6A) scancode 0x800f041f (toggle: 1)
[  194.078769] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  194.078772] keyup key 0x006c
[  194.078776] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  194.204414] RC6(6A) scancode 0x800f041f (toggle: 1)
[  194.204420] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  194.376145] RC6(6A) scancode 0x800f041f (toggle: 0)
[  194.376153] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  194.376156] keyup key 0x006c
[  194.376160] Nuvoton w836x7hg Infrared Remote Transceiver: key down 
event, key 0x006c, scancode 0x800f041f
[  194.500541] RC6(6A) scancode 0x800f041f (toggle: 0)
[  194.500548] Nuvoton w836x7hg Infrared Remote Transceiver: scancode 
0x800f041f keycode 0x6c
[  194.750393] keyup key 0x006c

greetings and thanks for your help

Stephan

