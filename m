Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JbYw4-0006I8-13
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 11:20:50 +0100
Received: by fg-out-1718.google.com with SMTP id 22so4598151fge.25
	for <linux-dvb@linuxtv.org>; Tue, 18 Mar 2008 03:20:33 -0700 (PDT)
Message-ID: <ea4209750803180320k7df82e5frd3b8655db492b134@mail.gmail.com>
Date: Tue, 18 Mar 2008 11:20:32 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: insomniac <insomniac@slackware.it>
In-Reply-To: <20080318002111.2a815091@slackware.it>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_19038_31083237.1205835632250"
References: <20080316182618.2e984a46@slackware.it>
	<ea4209750803171412x63a3a711t96614c03019aaf84@mail.gmail.com>
	<20080317221546.6a4dd75e@slackware.it>
	<ea4209750803171420t55f203eev3ba21b70d93bc39f@mail.gmail.com>
	<20080317222416.38cf913f@slackware.it>
	<ea4209750803171427x45224559l4b60f804401e6c87@mail.gmail.com>
	<ea4209750803171438x34e25fb5o6bbfa91b38defa2e@mail.gmail.com>
	<20080317234614.7b9a4c38@slackware.it>
	<ea4209750803171559q2ab79b17od0f6a6bead0dfcf6@mail.gmail.com>
	<20080318002111.2a815091@slackware.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] New unsupported device
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_19038_31083237.1205835632250
Content-Type: multipart/alternative;
	boundary="----=_Part_19039_32702429.1205835632250"

------=_Part_19039_32702429.1205835632250
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Could you try with the files I send?

.config must go to v4l-dvb/v4l/ folder (it's for just compiling dibcom
stuff),
dib0700_devices.c and dvb-usb-ids.h go to
v4l-dvb/linux/drivers/media/dvb/dvb-usb/

Albert

2008/3/18, insomniac <insomniac@slackware.it>:
>
> On Mon, 17 Mar 2008 23:59:07 +0100
>
> "Albert Comerma" <albert.comerma@gmail.com> wrote:
>
>
> > It's not clear that the patch worked with the differences of the
> > source (it has a reference to the identifier matrix). I will try to
> > add it just to check there's no problem with that. But tomorrw...
>
>
> Yes, they differ, so I tried to patch by hand. In attachment the patch
> I did based on Antti's patch and your tarball (after a make clean).
> Don't really know if that makes sense in my case.
>
> Regards,
>
> --
>
> Andrea Barberio
>
> a.barberio@oltrelinux.com - Linux&C.
> andrea.barberio@slackware.it - Slackware Linux Project Italia
> GPG key on http://insomniac.slackware.it/gpgkey.asc
> 2818 A961 D6D8 1A8C 6E84  6181 5FA6 03B2 E68A 0B7D
> SIP: 5327786, Phone: 06 916503784
>
>

------=_Part_19039_32702429.1205835632250
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Could you try with the files I send?<br><br>.config must go to v4l-dvb/v4l/ folder (it&#39;s for just compiling dibcom stuff),<br>dib0700_devices.c and dvb-usb-ids.h go to v4l-dvb/linux/drivers/media/dvb/dvb-usb/<br><br>Albert<br>
<br><div><span class="gmail_quote">2008/3/18, insomniac &lt;<a href="mailto:insomniac@slackware.it">insomniac@slackware.it</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
On Mon, 17 Mar 2008 23:59:07 +0100<br> <br>&quot;Albert Comerma&quot; &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt; wrote:<br> <br> <br>&gt; It&#39;s not clear that the patch worked with the differences of the<br>
 &gt; source (it has a reference to the identifier matrix). I will try to<br> &gt; add it just to check there&#39;s no problem with that. But tomorrw...<br> <br> <br>Yes, they differ, so I tried to patch by hand. In attachment the patch<br>
 I did based on Antti&#39;s patch and your tarball (after a make clean).<br> Don&#39;t really know if that makes sense in my case.<br> <br> Regards,<br> <br>--<br> <br>Andrea Barberio<br> <br> <a href="mailto:a.barberio@oltrelinux.com">a.barberio@oltrelinux.com</a> - Linux&amp;C.<br>
 <a href="mailto:andrea.barberio@slackware.it">andrea.barberio@slackware.it</a> - Slackware Linux Project Italia<br> GPG key on <a href="http://insomniac.slackware.it/gpgkey.asc">http://insomniac.slackware.it/gpgkey.asc</a><br>
 2818 A961 D6D8 1A8C 6E84&nbsp;&nbsp;6181 5FA6 03B2 E68A 0B7D<br> SIP: 5327786, Phone: 06 916503784<br> <br></blockquote></div><br>

------=_Part_19039_32702429.1205835632250--

------=_Part_19038_31083237.1205835632250
Content-Type: application/x-gzip; name=files.tgz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdybd5g6
Content-Disposition: attachment; filename=files.tgz

H4sIAJqW30cAA+w9a3PbtrL9av8KNGdOa7myQ1JPx3XPyBKdaCJLOno4zfRkOBQF2RxLpEpSdpKe
/Pe7C4AvkJQtO71t760niandxQJY7C4WqwWzsJfUf/nN7/qjwE+jUWO/4Uf+zZ5VpVFvNNSK2mh8
o8AHAJHa7zss/rPxA9Mj5BvPdYNtdA/h/6I/C7b+c3uGIjfm9M62qH9sfdU+cIHr1WrB+jeqSr0e
rz88K2qlrlW/IcpXHUXBz//z9X95SHq2s/lI5p59Rz2ycD0itIDMTJ/OieuQ4IaSjn1uuSv8hZpC
puNzMvPs+TXdJ4fwZ29yY/tk7bnXnrki8LjwKCW+uwjuTY+ekk/uhlimQzw6t/3As2ebgBI7IKYz
fwldrty5vfgEAGS1ceYwEuw0oN7KJ+6CfXjdn5LX1KGeuSTDzWxpWzB0izo+JSZ0jRD/BgY8+8TI
L2AAyG0sxkAuXGBsBrbrlAlM1YcHoh3z4RPSdtefPPv6JiAH7RLRFKV21BCTLpNxC2he7v/Ddqzl
Zk7JC2Ewxzcv9tPQCmj0ykJ4CtxAcC50nYauAk2pKxmYVq9nWoPp8AGABgcgDNsJcPksaiwd0zCt
wL5jsz3dB+lultRYm7A2B3kkZWxcJmilpdP9y0Fn2tONYWt0aXT0cbugyQsGZrKOwbhYPff+qO/a
Pj1qrdZLWFfqHfglctDrt0rQbH9v74W9IOYacJY5W1KmdMiGKx45mNOFuVkGr4hyZm4Cd4XTe+ku
FqXjFzA8mK+3sQISOi1zbq5BUQwUAyW/7e+hIA4OfRrwGRu+eUeh+7DZ3cxYeK4TUGdODsskB8zb
UWDqk0Po8Qt0Cobyxtys1+bmmpK+e2ceTUgNDOHAvDXJuQdK7S5LTJNuQBtNApNF03k97A4Ucn9j
WzdoFdTBCTMdhfEFtnNNVNQssYRiLFwJDMt1FvY1mhkyN1LQX7QP5AwnC3/2jm3NAjHMPer7AFU+
1pUygq2la90a7iYgBMAVgH0pk/wGKiLZRNNDASF/VFDI15Y8HqHt63BgCRI2suMZGLdhmWvs4rzV
7xhXby7If/nj9M0F9HgMQtisCWHjO1DJjz+SZglIDmr4WGOPCj5W48dK/KixRw0flVJ5H/jBGFRj
ZX4EdlWtdtIsRzDbAZjaqJ9UBUwL6WrNRi2GMTolZrYOVA6IPmvwuXYSU/hLd03TRAyEdPWITpM4
aRlOWsxJVdVyCoiUGswmd4G4zylYnggRawxjTKKfM/Ldw0vK9AkEZgT2iopmykf1pM4QSwe0yTKW
9I4uOcKyGgwDyrfeBMZqTa81w3YMtdk0Zp8CijrBdK78ZxtQUsboScKhRM7BDALTukm6k40/C70Q
OcSH0j7IWXJT3D0d+gF0hDRHP4G7O/ppDfvuKfisBXgSBrXn5AxGXGKGGjUGZ3a9tt2DqGWZuZZ6
mbDfxmA6Af9dOiUrf0np+kCF553bqzu3V5Xys/pPt5f7BwYol7ztpwS4B7nLzKENXfp056aJscRW
hS6UOpsVxCM4oIPvEovK3au5LhOtTDr6RWvamxid7jk2HRpdrW20Op2RPh6XC821RL6NtOAxy7ht
FfY8cLOeQ470/qCjXyHoC2o6qOjRT8Ky7IX6S6iA6ChUTVOAULQUHS4oYFDjhQ3Eg+aAMsmVAvQH
QyE/kLCDErpstZyx89hZRUMpldAc+tNej/wrnACByAB25VwzDTYQIf4+NiqIw2kxTtAdagKKJZrC
NawSHwaSrkwfKCMBCkUUck3IMvRwXJAxueghIax0IBBJCsVctKDbhAiRzXjytgHz77wiQ9txTGtJ
X06oB4pNrZdx1NPZQOTduTqHyKdjswg6+ITBC3K4nECM+jEbyuTED35wi53NjUbo2SG6TRCkQpso
WCAvX5IooEBrhE6HrNXGp4Y/NyDIVc/AbGWgFgPhTPKrsb5fgbrdnakh1HbuEKhmINoZbgh7hxH0
xoA9xbszqB/ETHH/YZBKohv6mcYUzozhtfDzvWcHgEZhgWGwSEZNxDoqD3ZYNKSqiWclfj6JyXnA
VMkNmFgYpcZQiJJQjizqQhmqagVGiSCc8rVpOwDUVA5iE4PVnNlL+zNSC1Jzub4x+dbKWDQF+Q1G
myEdYbD72RyFCbBKLewJYR5dYNMUnc/YpduyrpBlvVar1ET3IsRDphVQpCSUjT9NqwlarVI70ZJQ
oI36CxlAiIYMkC4B07B5Ldn9OqggXTVJx4O3fDByUCvJ7nlP6kkahnRNJW6uxVxzwBpbwkZyVVam
E+BoU0D6cc0EwGEzGkR0NTUBQzKxKgBaUw/23RVTWDzG+3BaC6IDhBzO9/Dfv230KTaqPWCjWqWh
lfNMtNBGd7HSHCN9pI0WmGjaQmNzzhporn0+wjxVrVmWzVOGVTKwyJDSLGPzTFCH5qnVKlnzVHPN
M8n1jzTPLUd4tMx7ex7cZDZisQWvl8vUAb6O6dkyqfBfTAMhknHMZZn4JmZ2nOt9HA8IDgYPD5yK
sVlcvyJrTPZBhMoCZPzlXEM841FQbYh7P61N399HwSmsscqCZWi/sn3rFZAtWGOgs5a3BnuGCLfd
ewtRNwzTA1atTnt5O/YgNmIZLnd/j9tYyjp5kqCmVZPGZc75EKEX0GmYD/7DXI9au2WDwukiYH9P
U6o1TdO4xoLBLfJlzKMZWbQRQshYhDjxUfyh8+je8Y3rB7ONjyIQMVeIEUGmb2CmFpeXYxAVh1Pw
a+NgQKuVBQKeH4rBGOnsnp3Fi9WEd4UHEhicB7RwxGmwIw47jcQHn5HennQH/XE5or8zl4X0V63e
VE/Q4m6wdv1C+uG7S2M4GMfZhL9l+jVlmqPuKWXO+JFsvimbn4zWKhcl52CiHnZOwjw9ryJnDnZL
bJxkGTzUpLp7k8buTTIZm52nlsnZ7Mwhh0HkJx+VVtHKEM884GORLZxu9wozF7zN1sSF8rGp/BDr
DwvU0Ib29r57yMPHR2/MHYnjfjyWx6Q0oi6elNPIS1OASFIJCz5wzFfkZirANfyMkQMmrLr9iT66
aLV1YzLt66NtaQzm9oRYs3mM/aTwimRWICAmoX/M6cJ2aJRXG4nBgYuDGF2JRLhpEg+OAvTXDUT2
fMclI/3f4AbBvQ16PWgIBkAkVxPqLjSFht4nWd7iO6rDeZlsKho5hAAbvzrDpocsfcTWAPq+pZ9+
qX445V9H2XH6KGQEHQAJOYR/VuYa1wMTTe7aP+YYWI716dYM1TzKTPFRoP/ED5zmDCZ7OZjoRn9g
vNXfG0PMN+odHNBZyM0KvKXhzQ/m5VhSYFzQexm/CGTe0/7xTDhN6nkHL0Zt8m+UC7kw7SWdv2DW
G+YXVWZzrBlOX/lwBkeo775jslCTH7Tkhwp+KBHBRDmNGVSO1A/fnmFSC8YXuNfXS8qHgt8YHthn
yqn9Y47YDN/+TE+J/cMPIn8q+AHqF/vDsbXxA3eFKsb7gI2Kj0Tg52ZgxtjKB8EklnJMyiCnHCuJ
PS3zPZ6bi6ZxFk6P4xJzZ7lZ9pfJe+rcOu49fnG+coE9WErgucslGDVqzyvyT+1n/PuifAB6Vgon
lPxU+cBdYaKTL5n4Na2UCSOAj34YrsJx/i1gLXcOoVT4pW1gO5+itKEYJp6af4PNXIENCv4Ff4/S
uJxOdMK2/RilCpTenwIKI+yI1dK9dpO0lRNOOxy800cynwrHXQ1600t9OpTRJ0l0Z/CuLxPUOUH7
Tavf13tZBlYKn8dhwSlUCa7WOFyT4UIoFRne5PCqDJ9xeE2GUw6vy3Ah2YYE1wS8KdNrHH4i0zc4
XJHhVQ4ft0e63hdr9/34143p0e9RN1PEJiee6D9PkJQdYb+fZOnmnG6kv+v2O1KPFSGxYa/1XkaJ
5b9ojScXg9G71ijTuB5ybg+ySLG648lAXviKWNZ2q9/We+E0/yVGnmsQYeactGGX8q4/kc6E/DyO
U+Zw2rRX9tIEapdYnGaiHVsktBo6S5pGWt0FTpOVTcArsrIJeFVWNgGvycom4HVZ2QS8ISubgDdl
ZRPwE1nZBNyUlU3AhZJfdTv6QMZZsiIKeKQzF+Bt38hYsX768LWECQ0wYesCIQTf0y8mMkrIffBW
RgjBj7qv32QaCeGnnIZACTl3+xfydNVGOK2OjBHCfi0ML4UTAn+v93qDdzJSSP0cjoIyalbk/wTe
KvCvAj3P8fACRQtdryBYpLrOoaiGht+ajmX2VbFYbwaXGZQm7S2HpHPVIZdwupBMrSpWbzw9n3Qn
vQyjatp7AaMJXdKAfgxkRsKeOnpPz0iiKhZ7ciUjxFLj6CRMM8cxCdRJsalUxUK3pp3uQIz4cuPb
soupzjI+/BD23wyZleN4BUos/HmrLZtEleb6coFcFDtsTlETQocQ6qo7mI5ldDPXnwukGHCfL9h+
gaPGbzbZF5vvbAcWhRd1dcpAtbbpnCw8CBIdBAZHEBuhhz4QhV/T8blWiqSEKh5HObF/EnBV9tUC
rsm+WsArsq8W8KrsqwW8JvtqAa/LvlrAG7KvFvCm7KsF/ET21QIulOztENZQH3XHb2WCWdaDCYxY
n1GL62cKN09ZbQpFQ8fXutKFtv5DXoVFjifiqNDhZ3yYQKuFjkoQaClHJWOrme1EIEKfkMOxnrPT
CFTo/lMbisA180xf4E7Spp/CmaFoO92WjJtl90mBsTJuSyBo2sqSqEWOW+AoTSnaaQReLd4OBIWQ
dA/0TmjB+NZek5lp3d6b3tyXVEKrZTZtgTiJ90MJE2lacovluErubiRwWq7PE8hqsc8TFLUcRytQ
9ZydQKCiSCHlCgWymRsQCKRY9NeDiawrlbkUfRb40B415wG9RRe6MP0AYt0r0nEdOOFGq4COMd6N
805vjVDFMLMU4xbJbWQ46vbD5WZ7gv4u7qGZDBNSu9lis1wS3/IodQg/eUeNGPuGGlpnyHzB8iCO
9YmkT7FhkJA4CFnJCCRx8Ksm6RMHP7Y5NRaZgx9N8kkc/OpJPomD30mST+LgN2dwmjn41ZJCThz8
zKTYTuTxCD7tnt4aSXNrpI/DQnL+jXtPrBvTceiSOJvVDDOPKWmHc0yYrkctE5YooqukQrdUxqCe
DEYg1tdHV2xrYSrRHZLZJghcJ+KkspEKTuM304uLXrhrjPut4fgNLHlEbKV0DewvNG8W7XUv4WTR
vUjQ86VU8g+VbA6NecF2IwaWQqcTClpSBjkpCSXJQHKUolZdVHQNX2Wr1seBbd2WSeuKepd0bpvk
ysXD6A6lW2v2FdeqqPA7rNkKi0OusHyLhIUAyQKR59aH1DL1IUqmPgQLrsnvWh9SWB5SS5SHKIny
EOXrlYc0VE0u4KoW1G/llW9l60JyireqyklNqt1SsmUh+ZVbvApfKtziZfhSWQivw5fKtrR6WI0W
VYVE84gqQhp1uR5ExVxhuhykpuUUg9ROZCA2VhpyJYjayNRp1ZJEIb9ENVqiCCSaQqIGRKtlSkDC
ApREBUi1mSkA2V7/8Rsh8TowGJcZAPi0EnCULwBqalOUd1wv3Zm5NNLNtCpe98qisfWXggsJW91G
4X2RPLfxt4/4Wj7i0S4i30dkXUTWQ2QdRNY/5LuHtHeoV5rVsuQcknRapLui4ihRMSb0P+Uf1Eoj
DdP2RT1nykVkGodWLdFGdp0qbhOeIgNDQpJTHaaKVcjxF6oojpPcRcpbcHeR9RZpZyEKsnJ9xe6F
Yus/vkJM+bNUiNUVrdZU643thWJ7FXHXmYE+BuayuHZslZG2jOC36uZ3swD9HRUlSw9WOx3jdzLB
ZywnolYQljPlVTOFl84SFUqFoR6SpouZ1lIVU04R0+WWIqacGqbLghqmghKmy4ISpkeX660NGcFF
/oCEdxRm/mW2v6AwEzUq69/5ehwEARtniTViwQ31KF6ldVywTZjg2r0HvuABzWu6wu/nbQcvqZAj
ck/Jkpp3NHm3WFzJrbN7K08plnryjbwav0X2zBt5j6g7k2qrnjDL/C5ZsQi7UpxkgJGx+piRbbnq
97Bk8svGMhfYlPjm2n54XY+ZnGXMaQDer6iirMRrPJ5TK0YwTPquyJOwMhkcre1HKHQNrGKGiFuJ
W7tfPaX7Vdz9E4rQcq+jR12kwcxTsvLNIg/xx9zMCzVBlj1eIP26tXBiETNMV89g+vBFwZwKu4Qa
pNaonL0gqDx0M5DtBg2FXOOLN/g3gw8e99i8G4864KXuD4Ufxuwy0V/w5Ff7Xz/5PXDBrx6F5eHJ
T1W+cnIo52Jfzp2hWm5yKP9Wn3yjT6YTxz8xFun8l4aKA2BVuobEc0TNinS5qIIhfD17PSg+AmZy
RSwvJJ8B1ZpWTgOBstlMU4acT5QcODsF5twcyrk4lHNvKOfakLIta5StgGXmy/01O4zlvzsFfQ42
cB18Nws67dBZhd402sqRtMmOb99yarnWOd0pDwy+RqcnrNNsn4ntBbtNey62fSbg2162krjdz1ok
L/cjNZNfuBmkpcrwbKoZPIMyPH+Hy+3NZxbZ4FEyhq7hkMre24SvMSl6ucsfMMCcGxxh6/itPO4d
9Tx7TouX+aE38yxoOlTIiyVgUAsKwcLdTA4W8l8fFFXx8m2VN9nf26h1AioEoz9lxd3iYhDbrgYX
xgWrK++334PO4WYcfoX4EmJbFkP793Zg3ZADbMdDTcv0abQNvhLMgeVJTTklMzjZ3J6mqGDffIX3
JMJXI0UNaskGXyCMpjPwzAv34MW78w77nrZj8xs+r8g/5/9xXpTDtj9E6o9OmQNhAiURzcfWJDw7
M6hHtBUGySR59FP6PUyMBy5cgQN4ZpiYWUxpJR9+h8Nzw8DCK0fsOJKK6pn4toVxRe4oEbWVcl/v
wU8UX7tb9cFuxYksveTREqAhYqE+X2F8igj90/iiTjFRwgtl/cjp9gL3otxmyHB2HyZwVIglmDeL
E5xq7YEEJ1a1/B+7AytescVCzsR9WLxkcsyTmuTyzefcrCfbBpJZT+Pm8yOycEm9+z2ycNlzSSLv
VqQHBcm3bdcxd7iNueNlzP3Cm6uJr/1hFsPEOS08gzPJ7pqle3l4Oeh0L/AcA9x3vTXJzj+7vrto
f2/XhJd0l3D3e5a7X7PcPXH42DzajtPPuYy5U/ucnNpuVzGZ22pKu4aU+XreJUyCtzC3d7BDaith
JJ3cbEbmiwHscy53mj4SPOiaCn3Tduf0KO/0Z7otvu1ufXg8+VtYjxFWXhqVa6Lkw5WHg+Tdb7v/
7YL/Si5Y4y640Fl9NRdc7A6VD7u54cdotvqwZj93UtrWSak7TordMDo/wndjY34Af/vBZrGAU/hy
6d77fL9hU4qvkhtwSgxVBKH23AjwJcHi0i3wxDzy3m/IDnzIVbetH+DjVbeDOZ324JIlEBE0jEBG
WP9ZYlWjT21tDNslXvydz+FNazoctqav9XLEIQIZ/cFVy5gYcHTaNohHsjC05zIZT7rtt4wJiLRW
KNLWlT5iFyRiVhEIi3Vbo20DAeENR4OUSDmIX9a4bE10Y/qARKb97rtur1dO8BCgR61qT291Jvrb
ZPN33T5eOjA6kyujM+i/7umP4vRoqYrFAbmqqKtPlOv2JR52+/1WuwdjidqHINDSyRUeOfVtDCb6
aATibycYhCCj3e3ro9fvQUDGz2MwAhjYuDt5/0zhdBI691QT7ESSrRVJdjsPDHSfI1cDPBqs80Wv
NX7z9JmwcPt5w5i2evHK8FF9DUsMXRyIWHua8uo/s9c8RFzUIi6vu69b5+8nCY0JIcYU952Ig1bE
IZZSrpAaGi2JWwJPaFyhkTwV8oW9vHFCvZXtmOw99dQJPHYn5kv0PwTwDoxJ67ynH8DeVc7dyDD6
iN7Z0mX/fUQca3MOsCxDfTTp6mPyn/29Y/bO+NTP/7R37b1t40h8/718CqEFbtNDm+ph+dFDgZNl
2REi2TpLTpzeLQQ/5NSoYwd2ctvcod/9OHxIlEhJ7m63u7izsLtZiz/ODIfD4ZDi4z10rDHI7Yax
NaQfMawggmlXyAIMIarLZSHEw8Cx3b5rE+Bqvb/H10FwwBfweQBReEPFf6NdaOrF6ucXJMty9/N2
s5uh+ITlfZ8WVEgjWba7eJ+gKGILK+4oF40kwdkk8W4Vw4Q0S4J3u9W5bM3DK5ILRy2bux0v9p8Z
kCVS6BJV1Xr1TCfBMTRF5tLK6yWMxo7lu8MBajTDvjs4Tx5eEekf98kM2cQd0/Z7Tlw+6TUHx0fv
/BOfrvb8ANqDiuxOvKvX5C0b4zXobxQCPuzW+FXyQN89pUTQOO9p8yn7Cb9XKxg9/RtoG50GxKo4
6Qv+g//7Jbs3IneSTwyHxyT7xzUaf6aVSi5A+Qc3xK81XDKcQ6E6i1Kzw+ZY2PqenCNDDpO5KAS7
SnaCnDBN95rk4L+MMMORLa7BoogiC3UKO43IcVa42X/JikBVs0wOCyhGGxeDXQvDioEEeEFvhWHR
BMwlJ/tku4D1dof13fYFEf0/ma3mQlz1p9clKdpPxBdBXhxtf8kEJazl+5pqGDZKGXZQCseolG22
bQr+D3Y74gOx8R6qGuZmeWnV2uLau3tkqco1asFwIUqiQOdVw7BZzrBTy3CyXf+83myyuiXXAZ1f
zu5neHizg6WYh1c1MrSO1GvFRtLzvAh1HNu/riadzw/w5byGiV5aYwr8gcly1C7eKQ+7p70yWN/N
YIZLwd08OVOYyJBPqeOpVZYsa8J7WMqEPA7MWqV9oXBY2msKpYdmpd1K4fCnAgyfrQUwC8XOt3Ho
fnDOCzlesSz4ADWuwyqerUbmBOuDAqlv1b/Ot5Zc41HuWmUXCvwSz6r8cWQyXhUtReLstVJnL73/
KLsUoM56S52RUdtgT3ZdFzMIk2e1McPyt7Ts7y/VUbbdKLXt9NQ5GArB9W9qUmPPWrU3zvqZuvPA
6vjoR/IpNs8eiYjeOpu72eNOcZ6TN9DJHcu2vlXKQsDe14aAWuN/rVP7Va3/F4wYZB/2y9uZdJ3V
V7Z+QlwYyJaNY3OLso4acJS3U87a8DqHr7U280irzvsDEhn2N7PDx6OGGVqzhg0zHym3lp6kPapS
85T2trzXqCdSh6xIkhXA+AYFML5tAc7InVfftV+Wf6/947fNmo5d/rHutyuW8W2KVelx9GM9ztd3
cMeOgAsuR3bZ1lG+p3r8y9oBXl/AH3hNFcLm4iQ9IdXOq7+e/d63Fp+eb/WQ+78vyAfv34gHLAUt
v/9bU3Vdz+7/bmg/qJquGerp/u/v8bw8e6lY7I7l2WbzTHb6Ia+5VO5nn/CB48gy3inL3fbHRyVZ
rh9RDnJl+KdkDyd90bu03ykoIZw9Kj7os61ojXd6553WgcFU++zlGfHnKFAPJtH7Z/ZzEnbf37Mf
gTUORuMoe9G/ib2R1XPG6NVLhb4MEcxuNsge8EfY65al7VbS14FnRbFv6MiLTSIeQdOHDidSvxvb
8O8ouLVQZ5QlhKPJsAcH0flOJmKIXll2p4XwPcfm5Qymlt76LJVnmTygnhP1IfDVQQYIB27sBrou
kdXVbU5BRFbXtwZO13OhFCkNvKgosK2OaUwldMLIGvYsbzR0+ExItZcguSwDKqkfTBqqFk8svpZQ
QvaDfBoMeZrd8ejKGZZQHAWeEXsuZwWXVhi7I9/xeRpBYMeBb9kSKihus+N+jiM2EaNEe7HlDUZd
N+LrCr4u9p3YnoTRyEd9nixnzkiILYzCMJPbBpZ81XDo2xALyEiFnFUFtsuTHcLpeEE0CvImFti+
0E5iTW83srzOFIWvyDaHkeXxykB2P5YaGdMFWJukwNS2+q7nwYLIjNG1i3hHo7g7ySkdf1ePr5zx
0PFi/J1+lKv0M/A1/tMGtp7CrDsNJ/DrHAlYUiWKA1Vkj8Zc02NvYiuKLPsyExAnICVOUFpvjNcM
oETMKHx6eNjtwbuFltXSGk36WQPVgmLRYJ+XKIpQSuw4yMh8qRKBV3fSGzgRlkUocMYQloNxLLj8
xAnmSJLv993JoJQpIKy2qlYCUHgNf/zuUShZ6+IwEATK5Jz4UYy68UoW9hSKX4XwO7o6rUQMvHZT
q9bHpNmsEaTnDtzouhJyHbTUhlkL0WukDdpBeFUJoWuo4DTpSlwU1UJ6UYT62UklBoa3Vo0C+x1V
LS86FoSaew0IdYalCLrcKtIrWkt/k3y2dw+uq5x3dVt/JW2duPGh1LjvOVPUYVfQ60btVpsnUkgP
NigK0ku5BN4kGlXJC0fO9OmQOCVv45tm1odESC7peULRgcAYMFTODygk22zWaDSrrMrohNG1qnc6
5Xqf6g2ton3gdN0or9kecjjt8nQ/MrRyM712Qm3aKc8dmpdaQy+XDnHXUCjZlGooUs5Rte2Tw+N+
PdtU6Shot1vlTHByecNGGoIgsia9XAdes9FqlzdBUsRGOf/hNIItiVU1YJZz/+BpqmGW1wC9oT7f
W0jS7XwfzE6Mkr6FOCatJVs5X+AlYeX1A1bSrrUCvU6HFVZMWklLMCMrCm044X//+FGx7uG0k9n2
7dVun8y2+E4XaltvbSgBrE+oKAWqJ+SOy+txNDbRILe8EJCuGeU12bV9w6xoyd6gFxlGhQC4sakd
QQkRTNEd3gaepxyIb8uHKiihGAKAV9Cb5axwekWbggpDgIoahd3V8d8jrRBkCBA/goNt8maYpujN
piA5S9MMrZIwPTtBnn9qm4UmSSLd9WGBPPZsm+yeDrJgF9fTsBtU2LIbIodRZesTC8U7JWZgdUUT
f1qud0wWfDbAfRqPsz7L8kJLOeyetkteWBiDQBc6FWiiMZAEjodHpM+Vjm9xuoVCa9+dOrnhye89
I/L/9ZD5P7b+db08XHz85jxq5v+aLa2Vzf+1Wj+oyPOp+mn+73s8sFCNr3xoiQ+z/aOyW+FjEyFu
hZHbZj3fz/bPF2fKX9A/CorMn/fru4+Pyrn9Cmb4Gm9MJZihDnLxSenuksfHxcdkr5w/kFcXc/bq
b8vk8HyxRBHAIUmAUsp9u368WGCftEiJwzkm+3u89Y1xnikfk9kS0QbLxdchzlDW7Z1CVjL/mF1N
AWLTUx8PaZg+f4Y0IPSv2X6NPfMef14B+m/PXq5XW0RISQdEbi+ML+N0nXTxPSzXv0YBAGLp9vD+
LoZMtw70wsixL+FDDFxhkGgiom9lCM2cNUSEZ49QP+Xa4xEhY7ZXEpA7vKJszMQQ04f25WjMAI2W
BDDpumHseI4djUdD18byqKuliGR7Hwix1mImQMheC1qmtjkvAcQTLDNcn2OKRbJv8c4KKnNjLmqG
bDGhbNR5WwQEo5CpttGRpF+7NhVTXSUdId3xA1zMP8HdUppYzoEzDNwpJdBZqCJgbA17qH4xwlQN
XUBcWsN+5Fyx+l+JpUw3FmGIrjZENpe3aHAfB5ZHKIE2dFNAXd2Mxl6PFUcXi3N16zBtm6Ky6NYy
htBEI/PcyBkNGUBiF2A2DKA1m2JBfHfgMY1r7ZXIwg9dSn85F7OTOQ4CaHbMhQBge16IKg1V1Dbb
FUaYLBai/V+7MLcZeJOQiGksRTGjG3eIapYVRBfrfeJFrm8V2ptqLkW90+1/zELaosw3bg9fiUMN
fTY7y69AvmPrjJ/YCmTBTulWJGo8jcYZdm7BfreED+sS7xZk3g1PYaEmjW1L/TwzDKMaemONfQZt
iFDiEelsFCl2R9XF2sY+L+5FE4JZaS1VJJZu1EK+OyKTkUxQCD+OyZCKizLoR2RgukDla6vHiMQ0
gjOIIlFnidATWJqYFWCpSsgX0an0S1lxi2jkkVPp0YBrcVQGJj3KsCzLkN93R+wsabWPg8cB6Y6S
tlheus/wcjS6YutIaGU1RduSgGO4L2ri0yxmWRZ/1DNyylfnc1H6AjiznPm8Uw3WeMqLZh2Yo7xo
lYHZzgnqOhKtVCHclu/yqinsTWVUV6V1QpFkfyNGt2Q2WNgpyujOReMr7illyKQMScKeGA3xzUy/
MOAXM0CogD9DNDMk/KpEZp5M7YhqKG7cJv2SqorukcUJMi+1momURXxmEKuZWDrS9cfXZIFVRlxr
LUXdFcApZQReCWBhFzURZ+qQBmWKDYr2jeRDC2f2aNgnCl4Ap7LAGLESrKs5yqLKC2CesthMcmKY
Oco1BTRzlEVryomR14bYrgtgnrKkuQ6j6zhyh7f57tnQdVEZeSxHVxd1QSOX6Lo7mmZk25pEEzlo
ShVBRT3koNYQCWmmHRHKIOpCloF1RCiDqI9CBuwYGAfIXZ0hr0TEQPTnIp4v8kzAW2NoN5HWYHQJ
cF4BpAQJUPSPogT9aabFpiZWvDQHU6Mmi3egw+fHG3w8ZYrORIBz0ZQpuhM6HGJflWuCtSKao61J
enLylZTTtipzOQyW6Vo1JLCbSNcR6oMV6CYvp66L7ppieca6qFmK4vjqeinfvp0nJxY3A+Yoik2P
lcSDz0O5kog2m8dm+tZ10WyRs0JehfvMzXWshiRyFfEp/Y6sBmQnxRB0p3EcOtYp3hSlkR92QqOY
o/HAATI06zP0OA4dUxLpCodOYOjcbIq+rnC4Cql8NLgQ3ahwDAsh2pY40LoDU0ibFm1GPKmF2Yzo
wYonWlCkIVpt8fgKhhSLWHqiCZVCLGn94SMkp9gH4Aw6KSJxMKJLxJgGjxH9IMGYGUbiL4ZOd+JZ
dE1LlUODWS58z3HXHffw10EyIGxLXJUARsOoftqHLE1Ju5VnYZ0IynKESB/0dASEssyP4YKzpFzm
9Vyiy5bZ6nBctFouNEvGRavlgq2FL4vEV8izZFzM47joPBdJACjNwnGRDEklWRrEWOayEWEBjpvW
0BqOiNtDeerLzuWJh/0bIh/OKxspIlO3vOHopkrfslFuaT5OHWIXSuYrY7/XMVu4b8HzvIbYFP3Q
ReCBFV7dIs9NgKbMh+eBMWA0hpYM224dqqCsr2+pmmTIlgKzvh4BRb9CpmjzRNXPK9lEUg6a9sQr
+Qh+4F6jANJ3h24cehnhxJB0fEV0ShuhRdrCUJcLI6QzJZIM1bMlkgPSUg7N4kR6SYaUA8ogibDK
j2DDeVYS9ZNvCzEsI4zHznXMTxDpR+G56ExSZ0W8zqCidVMostkby7tCobzGsJKZjCLWvjGuGFxs
maE7gFm+K2xmmkbiN1jGKW05YDlxajquS6fEJeMa8iWAazZ62xBpUlTWZoy2pE/33D6eXkejpJgW
Cgbi2TypKZlYK8uUzpWC1HSa/ohJeqza3HlhrJGjqj17mWyX69Vp8cTpOT2n5/ScntNzek7P6Tk9
p+f0nJ7Tc3pOz+k5Pafn9Jwe8vwXvquDawDIAAA=
------=_Part_19038_31083237.1205835632250
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_19038_31083237.1205835632250--
