Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <claesl@gmail.com>) id 1Jb9hG-0007uQ-72
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 08:23:51 +0100
Received: by fg-out-1718.google.com with SMTP id 22so4141442fge.25
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 00:23:46 -0700 (PDT)
Message-ID: <47DE1C7A.2060909@gmail.com>
Date: Mon, 17 Mar 2008 08:23:38 +0100
From: Claes Lindblom <claesl@gmail.com>
MIME-Version: 1.0
To: Igor <goga777@bk.ru>
References: <47CBEC8D.4050306@gmail.com>
	<E1JWBcW-000EkI-00.goga777-bk-ru@f128.mail.ru>
In-Reply-To: <E1JWBcW-000EkI-00.goga777-bk-ru@f128.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AzureWave VP 1041 DVB-S2 problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Igor wrote:
>> mplayer /dev/dvb/adapter1/dvr0
>>
>> mplayer says...
>>
>> TS file format detected.
>> VIDEO MPEG2(pid=515) AUDIO MPA(pid=652) NO SUBS (yet)!  PROGRAM N. 0
>> VIDEO:  MPEG2  544x576  (aspect 3)  25.000 fps  15000.0 kbps (1875.0 kbyte/s)
>>
>>
>> and the picture is shown.
>>     
>
>
> you can try with dvbsnoop or dvbstream
>
> http://allrussian.info/thread.php?postid=182975#post182975
>
> dvbstream -o 8192 | mplayer -
> or
> dvbsnoop -s ts -b -tsraw | mplayer -
>
> Igor
>   
Hi,
I tried dvbsnoop on a recorded TS but I dont't understand how to read 
the output so I attached some of the output in
this mail. Is there something wrong with the output? This should be a 
decoded output of "SVT HD".
If it helps, I could get a similar log of an uncoded channel as a reference.

Does anyone else have this problem or should it work "out of the box" 
with the mantis-driver, and the new szap?

dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/

------------------------------------------------------------
TS-Packet: 00000001   PID: (Unkown PID), Length: 188 (0x00bc)
from file: test.ts
------------------------------------------------------------
  0000:  47 02 00 14 f9 34 26 6c  44 cf 8f 41 e6 1d da b9   G....4&lD..A....
  0010:  4c c1 8c 63 ad 56 47 8f  c4 4a b8 3f cb 03 48 ff   L..c.VG..J.?..H.
  0020:  d3 55 3d f3 fc 7a af 37  22 6d 23 54 88 d6 79 e8   .U=..z.7"m#T..y.
  0030:  94 8e a0 f7 46 20 2a 42  bf 4b f2 ad 17 fe e1 ad   ....F *B.K......
  0040:  cf b0 23 b1 2d 70 ce 43  f7 11 62 1a 9a e0 1e eb   ..#.-p.C..b.....
  0050:  da 8d 96 f4 97 5a 0a 00  00 00 01 01 00 20 8a a6   .....Z....... ..
  0060:  f7 83 c8 d7 ff f4 f9 a8  de 1a 6c a1 7d b0 b9 3b   ..........l.}..;
  0070:  ab 3b a2 25 97 2a 3d 24  ce 37 98 c4 44 0f 65 94   .;.%.*=$.7..D.e.
  0080:  ed 86 66 b9 10 f1 57 57  26 6f 27 69 23 7b 22 44   ..f...WW&o'i#{"D
  0090:  a9 f5 7c f2 c0 bb 97 43  bd 06 b2 f0 d7 36 86 19   ..|....C.....6..
  00a0:  05 fc 9e 88 bb fd 5b ff  b6 0c b4 c1 a2 96 5a 4a   ......[.......ZJ
  00b0:  c3 89 b7 9a 18 d8 d3 d1  29 7b f5 d0               ........){..

Sync-Byte 0x47: 71 (0x47)
Transport_error_indicator: 0 (0x00)  [= packet ok]
Payload_unit_start_indicator: 0 (0x00)  [= Packet data continues]
transport_priority: 0 (0x00)
PID: 512 (0x0200)  [= ]
transport_scrambling_control: 0 (0x00)  [= No scrambling of TS packet 
payload]
adaptation_field_control: 1 (0x01)  [= no adaptation_field, payload only]
continuity_counter: 4 (0x04)  [= (sequence ok)]
    Payload: (len: 184)
    Data-Bytes:
          0000:  f9 34 26 6c 44 cf 8f 41  e6 1d da b9 4c c1 8c 63   
.4&lD..A....L..c
          0010:  ad 56 47 8f c4 4a b8 3f  cb 03 48 ff d3 55 3d f3   
.VG..J.?..H..U=.
          0020:  fc 7a af 37 22 6d 23 54  88 d6 79 e8 94 8e a0 f7   
.z.7"m#T..y.....
          0030:  46 20 2a 42 bf 4b f2 ad  17 fe e1 ad cf b0 23 b1   F 
*B.K........#.
          0040:  2d 70 ce 43 f7 11 62 1a  9a e0 1e eb da 8d 96 f4   
-p.C..b.........
          0050:  97 5a 0a 00 00 00 01 01  00 20 8a a6 f7 83 c8 d7   
.Z....... ......
          0060:  ff f4 f9 a8 de 1a 6c a1  7d b0 b9 3b ab 3b a2 25   
......l.}..;.;.%
          0070:  97 2a 3d 24 ce 37 98 c4  44 0f 65 94 ed 86 66 b9   
.*=$.7..D.e...f.
          0080:  10 f1 57 57 26 6f 27 69  23 7b 22 44 a9 f5 7c f2   
..WW&o'i#{"D..|.
          0090:  c0 bb 97 43 bd 06 b2 f0  d7 36 86 19 05 fc 9e 88   
...C.....6......
          00a0:  bb fd 5b ff b6 0c b4 c1  a2 96 5a 4a c3 89 b7 9a   
..[.......ZJ....
          00b0:  18 d8 d3 d1 29 7b f5 d0                            ....){..
==========================================================


------------------------------------------------------------
TS-Packet: 00000002   PID: (Unkown PID), Length: 188 (0x00bc)
from file: test.ts
------------------------------------------------------------
  0000:  47 02 00 15 66 3a 7f 34  90 6d 79 90 17 73 ce e5   G...f:.4.my..s..
  0010:  ca 58 c2 a1 94 32 d6 2b  46 f1 6f 62 34 2d 26 28   .X...2.+F.ob4-&(
  0020:  15 02 a4 3e 61 2d 1b 0e  25 2f b2 80 5d 7a c0 19   ...>a-..%/..]z..
  0030:  ed 0b 8d 84 7c bb d9 f6  c3 e9 fd 99 8f b7 05 33   ....|..........3
  0040:  d9 38 33 62 d6 34 7e 8e  95 d4 5d 60 94 28 19 e6   .83b.4~...]`.(..
  0050:  67 af 12 a8 9e c0 7f df  16 43 ab c9 67 d8 2c 79   g........C..g.,y
  0060:  e1 d8 77 36 ea 5f 74 6e  88 6e 33 97 04 05 15 78   ..w6._tn.n3....x
  0070:  b3 5e e6 31 ce 41 28 86  32 4f 92 7d 4a ab 71 ec   .^.1.A(.2O.}J.q.
  0080:  b2 91 65 ca a0 a4 7d cc  d9 64 3c bd a5 be e8 66   ..e...}..d<....f
  0090:  8d 93 ab 4f 02 23 95 3d  7c ec 2d 92 1e 09 0a d8   ...O.#.=|.-.....
  00a0:  c1 da 50 a2 e8 70 07 de  2e 8c b4 ba be 59 e0 ac   ..P..p.......Y..
  00b0:  bb f8 f4 58 f1 72 99 74  ea 7a 2e e4               ...X.r.t.z..

Sync-Byte 0x47: 71 (0x47)
Transport_error_indicator: 0 (0x00)  [= packet ok]
Payload_unit_start_indicator: 0 (0x00)  [= Packet data continues]
transport_priority: 0 (0x00)
PID: 512 (0x0200)  [= ]
transport_scrambling_control: 0 (0x00)  [= No scrambling of TS packet 
payload]
adaptation_field_control: 1 (0x01)  [= no adaptation_field, payload only]
continuity_counter: 5 (0x05)  [= (sequence ok)]
    Payload: (len: 184)
    Data-Bytes:
          0000:  66 3a 7f 34 90 6d 79 90  17 73 ce e5 ca 58 c2 a1   
f:.4.my..s...X..
          0010:  94 32 d6 2b 46 f1 6f 62  34 2d 26 28 15 02 a4 3e   
.2.+F.ob4-&(...>
          0020:  61 2d 1b 0e 25 2f b2 80  5d 7a c0 19 ed 0b 8d 84   
a-..%/..]z......
          0030:  7c bb d9 f6 c3 e9 fd 99  8f b7 05 33 d9 38 33 62   
|..........3.83b
          0040:  d6 34 7e 8e 95 d4 5d 60  94 28 19 e6 67 af 12 a8   
.4~...]`.(..g...
          0050:  9e c0 7f df 16 43 ab c9  67 d8 2c 79 e1 d8 77 36   
.....C..g.,y..w6
          0060:  ea 5f 74 6e 88 6e 33 97  04 05 15 78 b3 5e e6 31   
._tn.n3....x.^.1
          0070:  ce 41 28 86 32 4f 92 7d  4a ab 71 ec b2 91 65 ca   
.A(.2O.}J.q...e.
          0080:  a0 a4 7d cc d9 64 3c bd  a5 be e8 66 8d 93 ab 4f   
..}..d<....f...O
          0090:  02 23 95 3d 7c ec 2d 92  1e 09 0a d8 c1 da 50 a2   
.#.=|.-.......P.
          00a0:  e8 70 07 de 2e 8c b4 ba  be 59 e0 ac bb f8 f4 58   
.p.......Y.....X
          00b0:  f1 72 99 74 ea 7a 2e e4                            .r.t.z..
==========================================================


------------------------------------------------------------
TS-Packet: 00000003   PID: (Unkown PID), Length: 188 (0x00bc)
from file: test.ts
------------------------------------------------------------
  0000:  47 02 00 16 3d 88 89 a4  d7 1f f6 03 d0 28 1b 7e   G...=........(.~
  0010:  c6 e3 c6 17 97 f5 78 c0  c7 48 83 d3 a5 36 97 a3   ......x..H...6..
  0020:  20 0d 19 a9 fe ad d4 58  8e 2d 20 3a e7 c1 e2 80    ......X.- :....
  0030:  d7 a4 4f 66 cf d4 82 4c  b3 79 f0 c9 fa ee b3 0e   ..Of...L.y......
  0040:  ea e5 24 67 88 2f 4a f8  60 3d 94 00 ea 79 4d 65   ..$g./J.`=...yMe
  0050:  0b b4 0f 6a a7 0b 82 81  07 e1 cb 5f e5 e7 bd 3c   ...j......._...<
  0060:  c9 36 68 82 96 95 6c ed  f9 04 89 bc 16 52 6b 2e   .6h...l......Rk.
  0070:  27 f6 d8 be af 89 d9 e9  7a 1f 0a 16 97 5d c0 0f   '.......z....]..
  0080:  5f 67 24 1c 70 cc e9 19  96 1a 37 b4 ec 61 52 18   _g$.p.....7..aR.
  0090:  14 78 3c cf 89 0f ae a3  48 69 3a ee 95 89 ab b0   .x<.....Hi:.....
  00a0:  ea 71 43 95 06 b4 6f cc  c8 15 c2 e2 da 7e 10 14   .qC...o......~..
  00b0:  44 f3 49 1b 0e ae 94 5d  ed e9 6e ac               D.I....]..n.

Sync-Byte 0x47: 71 (0x47)
Transport_error_indicator: 0 (0x00)  [= packet ok]
Payload_unit_start_indicator: 0 (0x00)  [= Packet data continues]
transport_priority: 0 (0x00)
PID: 512 (0x0200)  [= ]
transport_scrambling_control: 0 (0x00)  [= No scrambling of TS packet 
payload]
adaptation_field_control: 1 (0x01)  [= no adaptation_field, payload only]
continuity_counter: 6 (0x06)  [= (sequence ok)]
    Payload: (len: 184)
    Data-Bytes:
          0000:  3d 88 89 a4 d7 1f f6 03  d0 28 1b 7e c6 e3 c6 17   
=........(.~....
          0010:  97 f5 78 c0 c7 48 83 d3  a5 36 97 a3 20 0d 19 a9   
..x..H...6.. ...
          0020:  fe ad d4 58 8e 2d 20 3a  e7 c1 e2 80 d7 a4 4f 66   
...X.- :......Of
          0030:  cf d4 82 4c b3 79 f0 c9  fa ee b3 0e ea e5 24 67   
...L.y........$g
          0040:  88 2f 4a f8 60 3d 94 00  ea 79 4d 65 0b b4 0f 6a   
./J.`=...yMe...j
          0050:  a7 0b 82 81 07 e1 cb 5f  e5 e7 bd 3c c9 36 68 82   
......._...<.6h.
          0060:  96 95 6c ed f9 04 89 bc  16 52 6b 2e 27 f6 d8 be   
..l......Rk.'...
          0070:  af 89 d9 e9 7a 1f 0a 16  97 5d c0 0f 5f 67 24 1c   
....z....].._g$.
          0080:  70 cc e9 19 96 1a 37 b4  ec 61 52 18 14 78 3c cf   
p.....7..aR..x<.
          0090:  89 0f ae a3 48 69 3a ee  95 89 ab b0 ea 71 43 95   
....Hi:......qC.
          00a0:  06 b4 6f cc c8 15 c2 e2  da 7e 10 14 44 f3 49 1b   
..o......~..D.I.
          00b0:  0e ae 94 5d ed e9 6e ac                            ...]..n.
==========================================================


------------------------------------------------------------
TS-Packet: 00000004   PID: (Unkown PID), Length: 188 (0x00bc)
from file: test.ts
------------------------------------------------------------
  0000:  47 02 00 17 c0 67 30 1f  13 bd c1 49 ae 18 24 12   G....g0....I..$.
  0010:  cc 49 27 1b 8f 20 87 a6  b7 9e 1d dd 35 da 28 10   .I'.. ......5.(.
  0020:  68 27 c6 bb 3d c1 00 a5  fd c5 3c 41 49 41 d2 8c   h'..=.....<AIA..
  0030:  94 16 c7 82 fa 1c 43 bc  f3 b3 3c 8f 30 e5 89 ef   ......C...<.0...
  0040:  20 08 5e 03 f1 bf 04 b0  c9 c4 87 c4 c3 de c8 bb    .^.............
  0050:  b7 6b ea 03 cd f4 f0 dc  a6 1f 40 4d 96 3a 0a 6d   .k........@M.:.m
  0060:  7b fc 02 7a 87 b8 d2 7d  01 81 19 2c 7b c7 4c 0e   {..z...}...,{.L.
  0070:  7b 28 4a d8 78 b7 dd 84  b5 ed 03 c2 41 b7 40 fb   {(J.x.......A.@.
  0080:  92 65 96 b5 a4 5d e6 b1  1e c8 6b 8d df 1f ce fb   .e...]....k.....
  0090:  06 f2 ac 4e 26 fd 62 96  18 48 14 29 dd 6f f4 a2   ...N&.b..H.).o..
  00a0:  f0 44 6e 45 ce f8 ea b5  1b 88 ee 75 d8 40 8e 0a   .DnE.......u.@..
  00b0:  b0 6c 6b b8 89 21 6e b4  e5 b2 54 66               .lk..!n...Tf

Sync-Byte 0x47: 71 (0x47)
Transport_error_indicator: 0 (0x00)  [= packet ok]
Payload_unit_start_indicator: 0 (0x00)  [= Packet data continues]
transport_priority: 0 (0x00)
PID: 512 (0x0200)  [= ]
transport_scrambling_control: 0 (0x00)  [= No scrambling of TS packet 
payload]
adaptation_field_control: 1 (0x01)  [= no adaptation_field, payload only]
continuity_counter: 7 (0x07)  [= (sequence ok)]
    Payload: (len: 184)
    Data-Bytes:
          0000:  c0 67 30 1f 13 bd c1 49  ae 18 24 12 cc 49 27 1b   
.g0....I..$..I'.
          0010:  8f 20 87 a6 b7 9e 1d dd  35 da 28 10 68 27 c6 bb   . 
......5.(.h'..
          0020:  3d c1 00 a5 fd c5 3c 41  49 41 d2 8c 94 16 c7 82   
=.....<AIA......
          0030:  fa 1c 43 bc f3 b3 3c 8f  30 e5 89 ef 20 08 5e 03   
..C...<.0... .^.
          0040:  f1 bf 04 b0 c9 c4 87 c4  c3 de c8 bb b7 6b ea 03   
.............k..
          0050:  cd f4 f0 dc a6 1f 40 4d  96 3a 0a 6d 7b fc 02 7a   
......@M.:.m{..z
          0060:  87 b8 d2 7d 01 81 19 2c  7b c7 4c 0e 7b 28 4a d8   
...}...,{.L.{(J.
          0070:  78 b7 dd 84 b5 ed 03 c2  41 b7 40 fb 92 65 96 b5   
x.......A.@..e..
          0080:  a4 5d e6 b1 1e c8 6b 8d  df 1f ce fb 06 f2 ac 4e   
.]....k........N
          0090:  26 fd 62 96 18 48 14 29  dd 6f f4 a2 f0 44 6e 45   
&.b..H.).o...DnE
          00a0:  ce f8 ea b5 1b 88 ee 75  d8 40 8e 0a b0 6c 6b b8   
.......u.@...lk.
          00b0:  89 21 6e b4 e5 b2 54 66                            .!n...Tf
==========================================================


------------------------------------------------------------
TS-Packet: 00000005   PID: (Unkown PID), Length: 188 (0x00bc)
from file: test.ts
------------------------------------------------------------
  0000:  47 02 00 18 23 d0 a6 e9  93 39 fe ea 3b e0 53 e7   G...#....9..;.S.
  0010:  0c a0 dc e8 92 d6 c1 bd  9d 42 93 00 ec f5 8e 01   .........B......
  0020:  67 18 5f 53 94 c9 91 c0  cd 40 67 e2 fa da ca f6   g._S.....@g.....
  0030:  f5 63 b0 1b c5 40 e1 b4  d1 c1 e2 9d 8e 03 72 19   .c...@........r.
  0040:  60 d1 f4 1e c9 1c 99 54  8b 1c 51 c8 b3 c6 88 05   `......T..Q.....
  0050:  ba d2 68 df d4 07 04 2d  f8 c3 a6 6e 45 14 60 b5   ..h....-...nE.`.
  0060:  ce a4 f1 57 2f 26 c9 ca  90 d8 00 1f c8 72 96 de   ...W/&.......r..
  0070:  bf dd bc ae 8f 00 9a 3e  1c 4c c7 48 32 fc 4a 2f   .......>.L.H2.J/
  0080:  01 6d 50 8f 5f 6d 78 5d  d0 ba 19 bd 92 5d 0f 10   .mP._mx].....]..
  0090:  f8 60 80 32 26 07 cb c6  f6 2d e8 48 39 9c 0f eb   .`.2&....-.H9...
  00a0:  94 64 7e e5 eb 2a 81 c6  5d f0 dc e3 a3 01 fa 00   .d~..*..].......
  00b0:  82 8e b4 bf b5 1b 7f c1  a2 f0 90 88               ............



Regards
Claes


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
